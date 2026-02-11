import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
class StatusItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const StatusItem({
    super.key,
    required this.icon,
    required this.label,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.background,
          child: Icon(
            icon,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}