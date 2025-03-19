import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:leave_mib/auth/authController.dart';
import 'dart:async';
import 'package:leave_mib/auth/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leave_mib/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    // options: FirebaseOptions(
    //     apiKey: "AIzaSyCdrHfrAQBDCnckpjBcF56p7aT0S1oYEsg",
    //     appId: "1:112530840436:android:82cab07babf08579b9aa21",
    //     messagingSenderId: "112530840436",
    //     projectId: "leave-mib")
  );
  await FirebaseMessaging.instance.requestPermission();
  Auth authController = Get.put(Auth());
  authController.autoLogin();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          textTheme: GoogleFonts.almaraiTextTheme(Theme.of(context).textTheme)),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/mib.jpg'), // Add your image here
      ),
    );
  }
}
