import 'package:flutter/material.dart';
import 'package:pws/screens/dashboard.dart';
import 'package:pws/screens/reminder_screen.dart';
import 'package:pws/screens/settings_screen.dart';
import 'package:pws/screens/signUpScreen.dart';
import 'package:pws/screens/splash_screen.dart';
import 'package:pws/screens/weather_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherScreen(),
    );
  }
}
