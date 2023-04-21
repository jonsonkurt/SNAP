import 'package:flutter/material.dart';
import 'package:snap/view/forgot_password_page.dart';
import 'package:snap/view/home_page.dart';
import 'package:snap/view/login_page.dart';
import 'analytics_page.dart';
import 'bottom_navigation_bar.dart';

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
          // Add code to perform a primary action related to the current screen
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
        return const ForgotPasswordPage();
      case 3:
        return const LoginPage();
      default:
        return Container();
    }
  }
}
