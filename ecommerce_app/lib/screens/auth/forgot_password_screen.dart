// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// SCREEN
// Button
import 'package:flutter_social_button/flutter_social_button.dart';
// FIREBASE
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce_app/services/firebase_auth_service.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<ForgotPassword> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isSigning = false;
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  Future<void> _forgotPassword() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Color(0xFF7AE582),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height *
                0.8, // Đẩy nội dung lên trên
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 30), // Tạo khoảng cách phía trên
                const Text(
                  'QUÊN MẬT KHẨU?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: const Text(
                    'Đừng lo lắng! Hãy nhập email của bạn đã đăng ký và chúng tôi sẽ gửi cho bạn mã để lấy lại mật khẩu',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30), // Đẩy Form xuống một chút
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.deepPurple),
                            ),
                            hintText: 'Email',
                            fillColor: Colors.grey[200],
                            filled: true,
                          ),
                          validator: (String? value) {
                            final RegExp emailRegExp =
                                RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                            if (!emailRegExp.hasMatch(value ?? '')) {
                              _focusNode.requestFocus();
                              return 'Email không đúng định dạng';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: ElevatedButton(
                          onPressed: _forgotPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: _isSigning
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'GỬI YÊU CẦU',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                        ),
                      ),
                    ],
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
