import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final List<IconData> icons;
  final int activeIndex;
  final Function(int) onTap;

  const MyBottomNavigationBar({
    super.key,
    required this.icons,
    required this.activeIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar(
      icons: icons,
      activeIndex: activeIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.verySmoothEdge,
      leftCornerRadius: 32,
      rightCornerRadius: 32,
      onTap: onTap,
      backgroundColor: const Color(0xFFa5885e),
      activeColor: const Color(0xFFfed269),
      inactiveColor: Colors.white,
    );
  }
}
