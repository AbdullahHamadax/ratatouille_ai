import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class Navigator extends StatelessWidget {
  const Navigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 80,
        elevation: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Iconsax.home),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.user),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.heart),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.shop),
            label: '',
          ),
        ],
      ),
      body: Container(),
    );
  }
}
