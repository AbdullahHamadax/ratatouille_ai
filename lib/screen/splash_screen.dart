import 'package:flutter/material.dart';
import 'package:recipe_ly/components/navigator.dart';
import '../services/appwrite_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AppwriteService.account.get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return NavigatorBar();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
