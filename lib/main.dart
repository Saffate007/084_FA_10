import 'package:flutter/material.dart';
import 'package:flutter_application_5/homeScreen/wellcome.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: "https://rzxgyloathjfhoafhgmk.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ6eGd5bG9hdGhqZmhvYWZoZ21rIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY5MjgzOTIsImV4cCI6MjA3MjUwNDM5Mn0.FgnAl798bb5BWehCXsislILYzIQLsksGB9vIGm_jUF8",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: WelcomePage());
  }
}
