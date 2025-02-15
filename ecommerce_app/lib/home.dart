import 'package:ecommerce_app/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTab = 0;
  late final List<Widget> screens;
  final FirebaseAuthService _auth = FirebaseAuthService();
  @override
  void initState() {
    super.initState();
    print(_auth.currentUser?.email);
    screens = [
      const Center(child: Text('Home Screen')),
      const Center(child: Text('Profile Screen')),
      const Center(child: Text('Settings Screen')),
    ];
  }

  late Widget currentScreen;
  @override
  Widget build(BuildContext context) {
    currentScreen = screens[currentTab];

    return Scaffold(
      body: currentScreen,
      backgroundColor: const Color(0xFF7AE582),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        onPressed: () {
          // _showBottomSheet(context);
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // buildBottomNavigationButton(0, 'home', 'Home'),
                  // buildBottomNavigationButton(1, 'people', 'Community'),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // buildBottomNavigationButton(2, 'folder', 'Folder'),
                  // buildBottomNavigationButton(3, 'profile', 'Profile'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


}