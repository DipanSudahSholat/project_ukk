import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:library_dhifan/screens/home_screen.dart';
import 'package:library_dhifan/screens/login_screen.dart';

 Future <void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
     options:  FirebaseOptions(
     apiKey: "AIzaSyAVeUlEnjjAM-hblqYI0pfxgpEtP6rvLd8",
     appId: "1:780807622086:android:6e5b2a014ad0ebcb1336c7",
     messagingSenderId: "780807622086",
     projectId: "libraryaccount",
   ),
   );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.brown
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),

    );
  }
}
