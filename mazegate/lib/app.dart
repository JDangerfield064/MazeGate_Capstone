import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/system_controller.dart';
import 'screens/splash_screen.dart';

class MazeGateApp extends StatelessWidget {
  const MazeGateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SystemController>(
      builder: (context, controller, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode:
          controller.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.indigo,
          ),
          darkTheme: ThemeData.dark(useMaterial3: true),
          home: const SplashScreen(),
        );
      },
    );
  }
}