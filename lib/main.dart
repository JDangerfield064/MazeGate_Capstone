import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'screens/main_navigation.dart';
void main() {
  runApp(const MazeGateApp());
}
class MazeGateApp extends StatelessWidget {
  const MazeGateApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MazeGate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.primary),
        ),
      ),
      home: const MainNavigation(),
    );
  }
}