import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyOTP extends StatefulWidget {
  final String email;
  const VerifyOTP({super.key, required this.email});

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isVerify = false;
  bool _canResend = false;
  late String _otp;
  late int _otpTime;
  int _remainTime = 60;
  late Timer _timer = Timer(Duration.zero, () {});

  @override
  void initState() {
    super.initState();
    _loadOTP();
  }

  Future<void> _loadOTP() async {
    final prefs = await SharedPreferences.getInstance();
    _otp = prefs.getString('otp') ?? '';
    _otpTime = prefs.getInt('otp_time') ?? 0;
    _startCountdown();
  }

  void _startCountdown() {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final timePassed = (currentTime - _otpTime) ~/ 1000;
    print("Thời gian đã trôi qua: $timePassed giây");

    if (timePassed >= 60) {
      setState(() {
        _canResend = true;
        _remainTime = 0;
      });
    } else {
      setState(() {
        _canResend = false;
        _remainTime = 60 - timePassed;
      });

      _timer?.cancel();
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_remainTime > 0) {
          setState(() {
            _remainTime--;
            print("Thời gian còn lại: $_remainTime");
          });
        } else {
          setState(() {
            _canResend = true;
            print("Có thể gửi lại OTP");
          });
          _timer?.cancel();
        }
      });
    }
  }

  Future<void> _verifyOTP() async {
    String enteredOTP = _controllers.map((e) => e.text).join();
    if (enteredOTP == _otp) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Xác thực thành công!')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('OTP không đúng!')));
    }
  }

  Future<void> _resendOTP() async {
    if (_canResend) {
      setState(() {
        _canResend = false;
        _remainTime = 60;
      });

      // Lưu lại thời gian gửi OTP mới
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('otp_time', DateTime.now().millisecondsSinceEpoch);

      _startCountdown();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('OTP mới đã được gửi!')));
    }
  }

  // 6 ô nhập OTP
  Widget _buildOTPBox(int index) {
    return Container(
      width: 50,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5)
            _focusNodes[index + 1].requestFocus();
          if (value.isEmpty && index > 0) _focusNodes[index - 1].requestFocus();
        },
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      backgroundColor: Color(0xFF7AE582),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 30),
                const Text('NHẬP MÃ OTP',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text('Hãy nhập 6 mã chữ số đã gửi đến',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text('${widget.email}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                ),
                const SizedBox(height: 10),
                Text(
                  _formatTime(_remainTime),
                  style: TextStyle(fontSize: 40, color: Colors.black),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) => _buildOTPBox(index)),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ElevatedButton(
                    onPressed: _isVerify ? null : _verifyOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    child: _isVerify
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('XÁC THỰC',
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: _canResend ? _resendOTP : null,
                  child: Text(
                    _canResend ? 'Gửi lại mã OTP' : 'Vui lòng đợi...',
                    style: _canResend
                        ? TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
