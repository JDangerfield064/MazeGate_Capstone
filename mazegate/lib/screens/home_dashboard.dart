import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/system_controller.dart';

class HomeDashboard extends StatelessWidget {
  final Function(int)? onNavigate;

  const HomeDashboard({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<SystemController>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0F1E) : const Color(0xFFF0F4FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _greeting(),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? const Color(0xFF7B9DBF)
                              : const Color(0xFF5A7A9F),
                          letterSpacing: 1.4,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Welcome back, ${controller.currentUserName}",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : const Color(0xFF0A0F1E),
                        ),
                      ),
                    ],
                  ),
                  Image.asset(
                    'assets/images/logo_transparent.png',
                    width: 44,
                    height: 44,
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Main Status Card
              _StatusHeroCard(
                isArmed: controller.isArmed,
                isDark: isDark,
                onToggle: () => _confirmToggle(context, controller),
              ),

              const SizedBox(height: 24),

              // Stats row
              Row(
                children: [
                  Expanded(
                    child: _StatTile(
                      label: "Devices",
                      value: "${controller.devices.length}",
                      icon: Icons.sensors,
                      color: const Color(0xFF1565C0),
                      isDark: isDark,
                      onTap: () => onNavigate?.call(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatTile(
                      label: "Alerts",
                      value: "${controller.alerts.length}",
                      icon: Icons.notifications_rounded,
                      color: controller.alerts.isNotEmpty
                          ? const Color(0xFFD32F2F)
                          : const Color(0xFF2E7D32),
                      isDark: isDark,
                      onTap: () => onNavigate?.call(1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatTile(
                      label: "Online",
                      value:
                      "${controller.devices.where((d) => d.isOnline).length}/${controller.devices.length}",
                      icon: Icons.wifi_rounded,
                      color: const Color(0xFF00897B),
                      isDark: isDark,
                      onTap: () => onNavigate?.call(2),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Quick Access
              Text(
                "SENSOR STATUS",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.6,
                  color: isDark
                      ? const Color(0xFF7B9DBF)
                      : const Color(0xFF5A7A9F),
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _SensorStatusCard(
                      icon: Icons.door_front_door_rounded,
                      label: "Doors",
                      devices: controller.devices
                          .where((d) => d.type.toLowerCase().contains('door'))
                          .toList(),
                      isDark: isDark,
                      onTap: () => onNavigate?.call(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SensorStatusCard(
                      icon: Icons.window_rounded,
                      label: "Windows",
                      devices: controller.devices
                          .where((d) => d.type.toLowerCase().contains('window'))
                          .toList(),
                      isDark: isDark,
                      onTap: () => onNavigate?.call(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SensorStatusCard(
                      icon: Icons.motion_photos_on_rounded,
                      label: "Motion",
                      devices: controller.devices
                          .where((d) => d.type.toLowerCase().contains('motion'))
                          .toList(),
                      isDark: isDark,
                      onTap: () => onNavigate?.call(2),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Recent Alerts
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "RECENT ALERTS",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.6,
                      color: isDark
                          ? const Color(0xFF7B9DBF)
                          : const Color(0xFF5A7A9F),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onNavigate?.call(1),
                    child: Text(
                      "See all",
                      style: TextStyle(
                        fontSize: 13,
                        color: const Color(0xFF1565C0),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              controller.alerts.isEmpty
                  ? _EmptyAlerts(isDark: isDark)
                  : Column(
                children: controller.alerts
                    .take(3)
                    .map((alert) => _AlertRow(
                  alert: alert,
                  isDark: isDark,
                ))
                    .toList(),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Greeting ─────────────────────────────────────────────────────────────────

String _greeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return "Good morning ☀️";
  if (hour < 17) return "Good afternoon 👋";
  return "Good evening 🌙";
}

// ─── Arm/Disarm Confirmation ─────────────────────────────────────────────────

void _confirmToggle(BuildContext context, SystemController controller) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final isArmed = controller.isArmed;
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: isDark ? const Color(0xFF111827) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        isArmed ? "Disarm System?" : "Arm System?",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : const Color(0xFF0A0F1E),
        ),
      ),
      content: Text(
        isArmed
            ? "This will disarm your security system. All sensors will stop monitoring."
            : "This will arm your security system. All sensors will begin monitoring.",
        style: TextStyle(
          color: isDark ? const Color(0xFF7B9DBF) : const Color(0xFF5A7A9F),
          height: 1.5,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel",
              style: TextStyle(color: Color(0xFF7B9DBF))),
        ),
        ElevatedButton(
          onPressed: () {
            controller.toggleSystem();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
            isArmed ? const Color(0xFF2E7D32) : const Color(0xFF7B1FA2),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(isArmed ? "Disarm" : "Arm",
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
      ],
    ),
  );
}

// ─── Status Hero Card ────────────────────────────────────────────────────────

class _StatusHeroCard extends StatelessWidget {
  final bool isArmed;
  final bool isDark;
  final VoidCallback onToggle;

  const _StatusHeroCard({
    required this.isArmed,
    required this.isDark,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isArmed
              ? [const Color(0xFF7B1FA2), const Color(0xFF4A148C)]
              : [const Color(0xFF1565C0), const Color(0xFF0D47A1)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (isArmed ? const Color(0xFF7B1FA2) : const Color(0xFF1565C0))
                .withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  isArmed ? Icons.lock_rounded : Icons.lock_open_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArmed ? "System Armed" : "System Disarmed",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isArmed
                          ? "All sensors active & monitoring"
                          : "Tap below to arm your system",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onToggle,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.18),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                isArmed ? "Disarm System" : "Arm System",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Stat Tile ───────────────────────────────────────────────────────────────

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF111827) : Colors.white,
          borderRadius: BorderRadius.circular(18),
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
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0A0F1E),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? const Color(0xFF7B9DBF)
                    : const Color(0xFF5A7A9F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sensor Status Card ──────────────────────────────────────────────────────

class _SensorStatusCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<dynamic> devices;
  final bool isDark;
  final VoidCallback onTap;

  const _SensorStatusCard({
    required this.icon,
    required this.label,
    required this.devices,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final triggered = devices.where((d) => d.isTriggered).length;
    final total = devices.length;
    final hasAlert = triggered > 0;
    final statusColor = total == 0
        ? const Color(0xFF757575)
        : hasAlert
        ? const Color(0xFFD32F2F)
        : const Color(0xFF2E7D32);
    final statusText = total == 0
        ? "None"
        : hasAlert
        ? "$triggered Alert${triggered > 1 ? 's' : ''}"
        : "Secure";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF111827) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: hasAlert
              ? Border.all(
            color: const Color(0xFFD32F2F).withValues(alpha: 0.4),
            width: 1.5,
          )
              : null,
          boxShadow: [
            BoxShadow(
              color: hasAlert
                  ? const Color(0xFFD32F2F).withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.07),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 26,
              color: statusColor,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF0A0F1E),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ),
            if (total > 0) ...[
              const SizedBox(height: 3),
              Text(
                "$total device${total > 1 ? 's' : ''}",
                style: TextStyle(
                  fontSize: 9,
                  color: isDark
                      ? const Color(0xFF7B9DBF)
                      : const Color(0xFF5A7A9F),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Alert Row ───────────────────────────────────────────────────────────────

class _AlertRow extends StatelessWidget {
  final dynamic alert;
  final bool isDark;

  const _AlertRow({required this.alert, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD32F2F).withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFD32F2F).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFD32F2F),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isDark ? Colors.white : const Color(0xFF0A0F1E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  alert.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? const Color(0xFF7B9DBF)
                        : const Color(0xFF5A7A9F),
                  ),
                ),
              ],
            ),
          ),
          Text(
            "${alert.timestamp.hour.toString().padLeft(2, '0')}:${alert.timestamp.minute.toString().padLeft(2, '0')}",
            style: TextStyle(
              fontSize: 11,
              color: isDark
                  ? const Color(0xFF7B9DBF)
                  : const Color(0xFF5A7A9F),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty Alerts ────────────────────────────────────────────────────────────

class _EmptyAlerts extends StatelessWidget {
  final bool isDark;
  const _EmptyAlerts({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: Color(0xFF2E7D32),
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "All Clear",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: isDark ? Colors.white : const Color(0xFF0A0F1E),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "No alerts to report",
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? const Color(0xFF7B9DBF)
                      : const Color(0xFF5A7A9F),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}