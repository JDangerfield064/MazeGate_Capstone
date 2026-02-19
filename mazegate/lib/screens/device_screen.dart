import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/device_model.dart';
import '../services/system_controller.dart';
import 'add_device_screen.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<SystemController>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final onlineDevices = controller.devices.where((d) => d.isOnline).length;
    final triggeredDevices = controller.devices.where((d) => d.isTriggered).length;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0F1E) : const Color(0xFFF0F4FA),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const AddDeviceScreen(),
            transitionsBuilder: (_, animation, __, child) =>
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 300),
          ),
        ),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text("Add Device",
            style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                "MAZEGATE",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.6,
                  color: isDark ? const Color(0xFF7B9DBF) : const Color(0xFF5A7A9F),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Devices",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0A0F1E),
                ),
              ),

              const SizedBox(height: 24),

              // Summary row
              Row(
                children: [
                  Expanded(
                    child: _SummaryChip(
                      label: "Total",
                      value: "${controller.devices.length}",
                      color: const Color(0xFF1565C0),
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SummaryChip(
                      label: "Online",
                      value: "$onlineDevices",
                      color: const Color(0xFF2E7D32),
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SummaryChip(
                      label: "Triggered",
                      value: "$triggeredDevices",
                      color: triggeredDevices > 0
                          ? const Color(0xFFD32F2F)
                          : const Color(0xFF2E7D32),
                      isDark: isDark,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              Text(
                "ALL DEVICES",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.6,
                  color: isDark ? const Color(0xFF7B9DBF) : const Color(0xFF5A7A9F),
                ),
              ),

              const SizedBox(height: 14),

              ...controller.devices.map(
                    (device) => Dismissible(
                  key: ValueKey(device.name + device.location),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD32F2F),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete_rounded, color: Colors.white, size: 28),
                        SizedBox(height: 4),
                        Text("Delete",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12)),
                      ],
                    ),
                  ),
                  confirmDismiss: (_) async {
                    return await showDialog<bool>(
                      context: context,
                      builder: (_) => _DeleteConfirmDialog(
                        deviceName: device.name,
                        isDark: isDark,
                      ),
                    ) ?? false;
                  },
                  onDismissed: (_) {
                    controller.removeDevice(device);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.delete_rounded,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 10),
                            Text("${device.name} removed"),
                          ],
                        ),
                        backgroundColor: const Color(0xFFD32F2F),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.all(16),
                      ),
                    );
                  },
                  child: _DeviceCard(
                    device: device,
                    isDark: isDark,
                    onTrigger: () => controller.triggerDevice(device),
                    onReset: () => controller.resetDevice(device),
                    isArmed: controller.isArmed,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Summary Chip ─────────────────────────────────────────────────────────────

class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _SummaryChip({
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? const Color(0xFF7B9DBF) : const Color(0xFF5A7A9F),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Device Card ──────────────────────────────────────────────────────────────

class _DeviceCard extends StatelessWidget {
  final DeviceModel device;
  final bool isDark;
  final bool isArmed;
  final VoidCallback onTrigger;
  final VoidCallback onReset;

  const _DeviceCard({
    required this.device,
    required this.isDark,
    required this.isArmed,
    required this.onTrigger,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final isTriggered = device.isTriggered;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isTriggered
            ? Border.all(
          color: const Color(0xFFD32F2F).withValues(alpha: 0.5),
          width: 1.5,
        )
            : Border.all(
          color: Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isTriggered
                ? const Color(0xFFD32F2F).withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              // Device icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isTriggered
                      ? const Color(0xFFD32F2F).withValues(alpha: 0.12)
                      : const Color(0xFF1565C0).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  _iconForDevice(device.name),
                  color: isTriggered
                      ? const Color(0xFFD32F2F)
                      : const Color(0xFF1565C0),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: isDark ? Colors.white : const Color(0xFF0A0F1E),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 12,
                          color: isDark
                              ? const Color(0xFF7B9DBF)
                              : const Color(0xFF5A7A9F),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          device.location,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? const Color(0xFF7B9DBF)
                                : const Color(0xFF5A7A9F),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: device.isMazeGate
                                ? const Color(0xFF1565C0).withValues(alpha: 0.1)
                                : const Color(0xFF00897B).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            device.isMazeGate ? "MazeGate" : device.brand,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: device.isMazeGate
                                  ? const Color(0xFF1565C0)
                                  : const Color(0xFF00897B),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          device.type,
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark
                                ? const Color(0xFF7B9DBF)
                                : const Color(0xFF5A7A9F),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Status badge
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: device.isOnline
                      ? const Color(0xFF2E7D32).withValues(alpha: 0.12)
                      : const Color(0xFF757575).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: device.isOnline
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFF757575),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      device.isOnline ? "Online" : "Offline",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: device.isOnline
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFF757575),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (isTriggered) ...[
            const SizedBox(height: 12),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFD32F2F).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Color(0xFFD32F2F), size: 16),
                  SizedBox(width: 8),
                  Text(
                    "Alert — Activity detected",
                    style: TextStyle(
                      color: Color(0xFFD32F2F),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 14),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: isArmed ? onTrigger : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD32F2F),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                      const Color(0xFFD32F2F).withValues(alpha: 0.3),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Trigger",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: OutlinedButton(
                    onPressed: onReset,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark
                          ? Colors.white
                          : const Color(0xFF0A0F1E),
                      side: BorderSide(
                        color: isDark
                            ? const Color(0xFF1F3A5F)
                            : const Color(0xFFDDE3EE),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Reset",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ),
                ),
              ),
            ],
          ),

          if (!isArmed) ...[
            const SizedBox(height: 10),
            Text(
              "Arm the system to enable triggering",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: isDark
                    ? const Color(0xFF7B9DBF)
                    : const Color(0xFF5A7A9F),
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _iconForDevice(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('atlas') || lower.contains('door') || lower.contains('window')) return Icons.door_front_door_rounded;
    if (lower.contains('argus') || lower.contains('motion')) return Icons.motion_photos_on_rounded;
    if (lower.contains('cerberus')) return Icons.videocam_rounded;
    if (lower.contains('helios') || lower.contains('camera')) return Icons.camera_indoor_rounded;
    if (lower.contains('ares') || lower.contains('siren')) return Icons.campaign_rounded;
    if (lower.contains('aegis') || lower.contains('lock')) return Icons.lock_rounded;
    return Icons.sensors_rounded;
  }
}

// ─── Delete Confirm Dialog ────────────────────────────────────────────────────

class _DeleteConfirmDialog extends StatelessWidget {
  final String deviceName;
  final bool isDark;

  const _DeleteConfirmDialog({
    required this.deviceName,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: isDark ? const Color(0xFF111827) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        "Remove Device",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : const Color(0xFF0A0F1E),
        ),
      ),
      content: Text(
        "Are you sure you want to remove \"$deviceName\" from your system?",
        style: TextStyle(
          color: isDark ? const Color(0xFF7B9DBF) : const Color(0xFF5A7A9F),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            "Cancel",
            style: TextStyle(
              color: isDark
                  ? const Color(0xFF7B9DBF)
                  : const Color(0xFF5A7A9F),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD32F2F),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text(
            "Remove",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}