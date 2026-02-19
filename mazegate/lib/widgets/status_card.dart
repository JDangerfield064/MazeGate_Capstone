import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
class StatusCard extends StatelessWidget {
  final bool isArmed;
  const StatusCard({
    super.key,
    required this.isArmed,
  });
  @override
  Widget build(BuildContext context) {
    final String statusText = isArmed ? 'Secure' : 'Disarmed';
    final String subtitleText = isArmed
        ? 'Your home is protected.'
        : 'Your system is currently off.';
    final Color statusColor =
    isArmed ? AppColors.success : AppColors.warning;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Home Status',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitleText,
            style: const TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
