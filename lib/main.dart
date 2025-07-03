import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pws/screens/dashboard.dart';
import 'package:pws/screens/home_page.dart';
import 'package:pws/screens/main_page.dart';
import 'package:pws/screens/signInScreen.dart';
import 'package:pws/screens/crop_calendar_screen.dart';
import 'package:pws/screens/reminder_screen.dart';
import 'package:pws/screens/settings_screen.dart';
import 'package:pws/screens/signUpScreen.dart';
import 'package:pws/screens/splash_screen.dart';

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
      home: Builder(
        builder: (context) => SplashScreen(
          onFinish: () {
            Navigator.pushReplacementNamed(context, '/mainPage');
          },
        ),
      ),
      routes: {
        '/home': (context) => HomeScreen(),
        '/login': (context) => SignInScreen(),
        '/signup': (context) => SignUpScreen(
          navigate: (routename) {
            Navigator.pushNamed(context, '/dashboard');
          },
        ),
        '/dashboard': (context) => Dashboard(),
        '/mainPage': (context) => MainPage(),
        '/settings': (context) => SettingsScreen(),
        '/reminder': (context) => ReminderScreen(),
        '/calendar': (context) => CropCalendarScreen(),
      },
    );
  }
}
