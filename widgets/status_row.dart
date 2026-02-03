import 'package:flutter/material.dart';
import 'status_item.dart';

class StatusRow extends StatelessWidget {
  const StatusRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StatusItem(
          icon: Icons.door_front_door,
          label: 'Doors',
        ),
        StatusItem(
          icon: Icons.window,
          label: 'Windows',
        ),
        StatusItem(
          icon: Icons.motion_photos_on,
          label: 'Motion',
        ),
      ],
    );
  }
}