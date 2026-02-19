import 'package:flutter/material.dart';
import '../models/alert_model.dart';

class AlertTile extends StatelessWidget {
  final AlertModel alert;

  const AlertTile({
    super.key,
    required this.alert,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: const Icon(Icons.warning, color: Colors.red),
        title: Text(
          alert.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(alert.description),
      ),
    );
  }
}