import 'package:flutter/material.dart';
import 'package:pws/screens/home_page.dart';
import 'package:pws/screens/signInScreen.dart';
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
      home: HomeScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/login': (context) => SignInScreen(),
        '/signup': (context) => SignUpScreen(
          navigate: (routename) {
            Navigator.pushNamed(context, '/login');
          },
        ),
      },
    );
  }
}
