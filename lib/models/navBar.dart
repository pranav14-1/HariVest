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
  int selectedIndex = 3;

  final List<Widget> pages = [
    CommunityForumScreen(key: ValueKey('Community')),
    CropCalendarScreen(key: ValueKey('Calendar')),
    Dashboard(key: ValueKey('Dashboard')),
    WeatherScreen(key: ValueKey('Weather')),
    ReminderScreen(key: ValueKey('Reminder')),
  ];

  int _previousIndex = 3;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 900),
          switchInCurve: Curves.easeOutExpo,
          switchOutCurve: Curves.easeInExpo,
          layoutBuilder: (currentChild, previousChildren) {
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                ...previousChildren,
                if (currentChild != null) currentChild,
              ],
            );
          },
          transitionBuilder: (child, animation) {
            final isForward = selectedIndex >= _previousIndex;
            final rotateAnim = Tween<double>(
              begin: isForward ? 1.0 : -1.0,
              end: 0.0,
            ).animate(animation);

            final scaleAnim = Tween<double>(
              begin: 0.85,
              end: 1.0,
            ).animate(animation);

            return AnimatedBuilder(
              animation: animation,
              child: child,
              builder: (context, child) {
                final angleY = rotateAnim.value * 1.2; // ~70 degrees
                final angleX = rotateAnim.value * 0.3; // ~17 degrees
                final scale = scaleAnim.value;
                final shadow = BoxShadow(
                  color: Colors.black.withOpacity(0.18 * (1 - animation.value)),
                  blurRadius: 30 * (1 - animation.value),
                  spreadRadius: 8 * (1 - animation.value),
                  offset: Offset(0, 12 * (1 - animation.value)),
                );
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0015)
                    ..rotateY(angleY)
                    ..rotateX(angleX)
                    ..scale(scale),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [shadow],
                    ),
                    child: Opacity(
                      opacity: animation.value.clamp(0.0, 1.0),
                      child: child,
                    ),
                  ),
                );
              },
            );
          },
          child: KeyedSubtree(
            key: ValueKey(selectedIndex),
            child: pages[selectedIndex],
          ),
        ),
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
                if (index == selectedIndex) return;
                setState(() {
                  _previousIndex = selectedIndex;
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
