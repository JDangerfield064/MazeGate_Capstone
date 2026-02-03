// lib/screens/home_dashboard.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/status_card.dart';
import '../widgets/status_row.dart';
import '../widgets/primary_button.dart';
class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'MazeGate',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            StatusCard(),
            SizedBox(height: 24),
            Text(
              'Quick Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 12),
            StatusRow(),
            Spacer(),
            PrimaryButton(
              label: 'Disarm System',
            ),
          ],
        ),
      ),
    );
  }
}