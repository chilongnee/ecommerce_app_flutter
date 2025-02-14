import 'package:ecommerce_app/home.dart';
import 'package:ecommerce_app/screens/auth/login/login_screen.dart';
import 'package:ecommerce_app/screens/auth/register/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDo-Sb_puzcpIgcpLL9suqglcMVpZ1hyB4",
      appId: "1:1087762757441:android:88a016ddee6b6c798953c0",
      messagingSenderId: "1087762757441",
      projectId: "ecommerce-app-flutter-45845",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
      MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ), 
        home: AuthWidget(),
        debugShowCheckedModeBanner: false,
      );
  }
}

class AuthWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  User? firebaseUser = FirebaseAuth.instance.currentUser;
  Widget firstWidget;

  if (firebaseUser != null) {
    firstWidget = Home();
  } else {
    firstWidget = SignUp();
  }
    return firstWidget;
  }
}
