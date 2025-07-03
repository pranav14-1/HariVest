import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pws/screens/home_page.dart';
import 'package:pws/screens/signInScreen.dart';
import 'package:pws/screens/signUpScreen.dart';
import 'package:pws/screens/dashboard.dart';
import 'package:pws/models/navBar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  print("Dotenv loaded");

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: FirebaseAuth.instance.currentUser != null
          ? const Navbar() // Go to bottom nav/dashboard
          : const HomeScreen(), // Go to login/signup screen

      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const SignInScreen(),
        '/signup': (context) => SignUpScreen(
          navigate: (routename) {
            Navigator.pushNamed(context, '/navbar');
          },
        ),
        '/dashboard': (context) => const Dashboard(),
        '/navbar': (context) => const Navbar(),
      },
    );
  }
}
