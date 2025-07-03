import 'package:flutter/material.dart';
import 'package:pws/screens/signUpScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpScreen(
        navigate: (route) {
          // For now, just print or show a dialog
          print('Navigate to: $route');
        },
      ),
    );
  }
}
