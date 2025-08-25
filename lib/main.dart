import 'package:flutter/material.dart';
import 'package:flutter_application_5/homeScreen/signinpage.dart';
import 'package:flutter_application_5/homeScreen/signuppage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SignUpPage(),
    );
  }
}
