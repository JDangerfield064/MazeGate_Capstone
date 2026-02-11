import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/alert_model.dart';
import '../widgets/alert_tile.dart';
class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final List<AlertModel> alerts = [
      AlertModel(
        title: "Front Door Opened",
        location: "Front Door",
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isCritical: true,
      ),
      AlertModel(
        title: "Motion Detected",
        location: "Living Room",
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      AlertModel(
        title: "System Armed",
        location: "Home",
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Alerts",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: alerts
              .map((alert) => AlertTile(alert: alert))
              .toList(),
        ),
      ),
    );
  }
}