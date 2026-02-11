import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/status_card.dart';
import '../widgets/status_row.dart';
import '../widgets/primary_button.dart';
class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});
  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}
class _HomeDashboardState extends State<HomeDashboard> {
  bool isArmed = true;
  void toggleSystem() {
    setState(() {
      isArmed = !isArmed;
    });
  }
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
          children: [
            StatusCard(isArmed: isArmed),
            const SizedBox(height: 24),
            const Text(
              'Quick Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            const StatusRow(),
            const Spacer(),
            PrimaryButton(
              label: isArmed ? 'Disarm System' : 'Arm System',
              onPressed: toggleSystem,
            ),
          ],
        ),
      ),
    );
  }
}