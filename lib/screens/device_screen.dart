import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/device_model.dart';
import '../widgets/device_tile.dart';
class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final List<DeviceModel> devices = [
      DeviceModel(
        name: "Front Door Sensor",
        location: "Front Door",
        isOnline: true,
      ),
      DeviceModel(
        name: "Living Room Motion",
        location: "Living Room",
        isOnline: true,
        isTriggered: true,
      ),
      DeviceModel(
        name: "Garage Camera",
        location: "Garage",
        isOnline: false,
      ),
    ];
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Devices",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: devices
              .map((device) => DeviceTile(device: device))
              .toList(),
        ),
      ),
    );
  }
}