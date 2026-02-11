import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/alert_model.dart';
class AlertTile extends StatelessWidget {
  final AlertModel alert;
  const AlertTile({
    super.key,
    required this.alert,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            alert.isCritical ? Icons.warning : Icons.notifications,
            color: alert.isCritical
                ? AppColors.warning
                : AppColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert.location,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(alert.timestamp),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  String _formatDate(DateTime date) {
    return "${date.month}/${date.day}/${date.year} • ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}