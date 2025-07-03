import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pws/screens/dashboard.dart';

import 'package:pws/screens/home_page.dart';
import 'package:pws/screens/signInScreen.dart';
import 'package:pws/screens/signUpScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
            Navigator.pushNamed(context, '/dashboard');
          },
        ),
        '/dashboard' : (context) => Dashboard(),
      },
    );
  }
}
