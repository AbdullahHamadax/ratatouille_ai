import 'package:flutter/material.dart';
import 'package:recipe_ly/components/navigator.dart';
import 'package:recipe_ly/consts/app_color.dart';
import 'package:recipe_ly/screen/splash_screen.dart';
import 'services/appwrite_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppwriteService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.carlolinaBlue),
          useMaterial3: true,
        ),
        home: const SplashScreen()
        // home: SplashScreen(),
        );
  }
}
