import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_ly/screen/camera_screen.dart';
import 'package:recipe_ly/screen/history_screen.dart';
import 'package:recipe_ly/screen/home_screen.dart';

class NavigatorBar extends StatefulWidget {
  const NavigatorBar({super.key});

  @override
  State<NavigatorBar> createState() => NavigationScreenState();
}

class NavigationScreenState extends State<NavigatorBar> {
  int currentPageIndex = 1;

  final List<Widget> screens = [
    HistoryScreen(key: UniqueKey()),
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
      if (index == 0) {
        // Refresh the HistoryScreen when navigating to it
        screens[0] = HistoryScreen(key: UniqueKey());
      }
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
            if (index == 0) {
              // Refresh the HistoryScreen when navigating to it
              screens[0] = HistoryScreen(key: UniqueKey());
            }
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Iconsax.shopping_cart),
            label: 'history',
          ),
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
