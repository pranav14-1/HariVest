import 'package:flutter/material.dart';
import 'package:pws/screens/communityForumScreen.dart';
import 'package:pws/screens/crop_calendar_screen.dart';
import 'package:pws/screens/dashboard.dart';
import 'package:pws/screens/reminder_screen.dart';
import 'package:pws/screens/weather_screen.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int selectedIndex = 2;

  final List<Widget> pages = [
    CommunityForumScreen(key: ValueKey('Community')),
    CropCalendarScreen(key: ValueKey('Calendar')),
    Dashboard(key: ValueKey('Dashboard')),
    WeatherScreen(key: ValueKey('Weather')),
    ReminderScreen(key: ValueKey('Reminder')),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // 3D-Like Animated Transition
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          switchInCurve: Curves.easeOutBack,
          switchOutCurve: Curves.easeInBack,
          transitionBuilder: (child, animation) {
            final rotate = Tween(begin: 0.8, end: 1.0).animate(animation);
            final scale = Tween(begin: 0.9, end: 1.0).animate(animation);
            return AnimatedBuilder(
              animation: animation,
              child: child,
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // perspective
                    ..rotateX((1 - rotate.value) * 0.4)
                    ..scale(scale.value),
                  child: Opacity(opacity: animation.value.clamp(0.0, 1.0), child: child),
                );
              },
            );
          },
          child: pages[selectedIndex],
        ),

        // 3D-Styled BottomNavigationBar
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE0E0E0), Color(0xFFFFFFFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, -4),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              currentIndex: selectedIndex,
              selectedItemColor: Colors.blueAccent,
              unselectedItemColor: Colors.grey,
              onTap: (index) async {
                await Future.delayed(const Duration(milliseconds: 200));
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
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.cloud),
                  label: 'Weather',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  label: 'Reminder',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
