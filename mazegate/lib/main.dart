import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'services/system_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final controller = SystemController();
  await controller.loadSystemState();

  runApp(
    ChangeNotifierProvider(
      create: (_) => controller,
      child: const MazeGateApp(),
    ),
  );
}