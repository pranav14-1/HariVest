import 'package:flutter/material.dart';
import 'package:pws/screens/communityForumScreen.dart';
import 'package:pws/screens/crop_calendar_screen.dart';
import 'package:pws/screens/dashboard.dart';
import 'package:pws/screens/reminder_screen.dart';
import 'package:pws/screens/settings_screen.dart';
import 'package:pws/screens/weather_screen.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int selectedIndex = 3;

  final List<Widget> pages = [
    CommunityForumScreen(),
    CropCalendarScreen(),
    WeatherScreen(),
    Dashboard(),
    ReminderScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: pages[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          onTap: (index) async {
            await Future.delayed(const Duration(milliseconds: 300));
            setState(() {
              selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'Community',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.cloud), label: 'Weather'),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Reminder',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.blueGrey,
        ),
      ),
    );
  }
}
