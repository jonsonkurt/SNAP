import 'package:flutter/material.dart';
import 'analytics_page.dart';
import 'bottom_navigation_bar.dart';
import 'home_page.dart';
import 'plants_crops_page.dart';
import 'profile_page.dart';
import 'record_page.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  int _currentScreenIndex = 0;
  final List<IconData> _iconList = [
    Icons.home,
    Icons.trending_up_rounded,
    Icons.spa_rounded,
    Icons.account_circle_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Code to add new recording
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const RecordPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                var begin = const Offset(0.0, 1.0);
                var end = Offset.zero;
                var curve = Curves.ease;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
        },
        backgroundColor: const Color(0xFFa5885e),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        color: const Color(0xFF518554),
        child: MyBottomNavigationBar(
          icons: _iconList,
          activeIndex: _currentScreenIndex,
          onTap: (index) => setState(() => _currentScreenIndex = index),
        ),
      ),
    );
  }

  Widget _buildScreen() {
    switch (_currentScreenIndex) {
      case 0:
        return const HomePage();
      case 1:
        return const AnalyticsPage();
      case 2:
        return const PlantsCropsPage();
      case 3:
        return const ProfilePage();
      default:
        return Container();
    }
  }
}
