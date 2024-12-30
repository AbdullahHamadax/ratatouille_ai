import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_ly/screen/camera_screen.dart';
import 'package:recipe_ly/screen/home_screen.dart';

class NavigatorBar extends StatefulWidget {
  const NavigatorBar({super.key});

  @override
  State<NavigatorBar> createState() => NavigationScreenState();
}

class NavigationScreenState extends State<NavigatorBar> {
  int currentPageIndex = 0;
  final List<Widget> screens = [
    HomeScreen(),
    CameraScreen(),
  ];

  Widget _buildIndexedStack() {
    return IndexedStack(
      index: currentPageIndex,
      children: screens,
    );
  }

  void navigateToPage(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 80,
        elevation: 0,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Iconsax.home),
            label: 'home',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.camera),
            label: 'camera',
          ),
        ],
      ),
      body: _buildIndexedStack(),
    );
  }
}
