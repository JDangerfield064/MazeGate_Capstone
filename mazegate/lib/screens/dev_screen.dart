import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/system_controller.dart';

class DeveloperToolsScreen extends StatefulWidget {
  const DeveloperToolsScreen({super.key});

  @override
  State<DeveloperToolsScreen> createState() => _DeveloperToolsScreenState();
}

class _DeveloperToolsScreenState extends State<DeveloperToolsScreen> {
  final Map<String, int> _signalStrength = {};
  final Map<String, int> _batteryLevel = {};
  final Map<String, String> _lastPing = {};
  bool _allOfflineOverride = false;

  @override
  void initState() {
    super.initState();
    _generateMockHealth();
  }

  void _generateMockHealth() {
    final controller = Provider.of<SystemController>(context, listen: false);
    for (final device in controller.devices) {
      _signalStrength[device.name] = 60 + (device.name.hashCode.abs() % 40);
      _batteryLevel[device.name] = 20 + (device.name.hashCode.abs() % 80);
      _lastPing[device.name] = _pingLabel(device.name.hashCode.abs() % 30);
    }
  }

  String _pingLabel(int secondsAgo) {
    if (secondsAgo < 5) return "Just now";
    if (secondsAgo < 60) return "${secondsAgo}s ago";
    return "${secondsAgo ~/ 60}m ago";
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<SystemController>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF0A0F1E) : const Color(0xFFF0F4FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text("MAZEGATE",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.6,
                    color: isDark
                        ? const Color(0xFF7B9DBF)
                        : const Color(0xFF5A7A9F),
                  )),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text("Dev Tools",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color:
                        isDark ? Colors.white : const Color(0xFF0A0F1E),
                      )),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7B1FA2).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text("DEV ONLY",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF7B1FA2),
                          letterSpacing: 0.8,
                        )),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // App Info
              _SectionLabel(label: "APP INFO", isDark: isDark),
              const SizedBox(height: 12),
              _InfoCard(isDark: isDark, rows: [
                _InfoRow(label: "Version", value: "1.0.0-prototype"),
                _InfoRow(label: "Environment", value: "Development"),
                _InfoRow(
                    label: "Logged In As",
                    value: controller.currentUserEmail ?? "Unknown"),
                _InfoRow(
                    label: "System State",
                    value: controller.isArmed ? "ARMED" : "DISARMED",
                    valueColor: controller.isArmed
                        ? const Color(0xFF7B1FA2)
                        : const Color(0xFF2E7D32)),
                _InfoRow(
                    label: "Total Devices",
                    value: "${controller.devices.length}"),
                _InfoRow(
                    label: "Active Alerts",
                    value: "${controller.alerts.length}",
                    valueColor: controller.alerts.isNotEmpty
                        ? const Color(0xFFD32F2F)
                        : null),
                _InfoRow(
                    label: "Event Log Entries",
                    value: "${controller.eventLog.length}"),
              ]),

              const SizedBox(height: 28),

              // Device Health
              _SectionLabel(label: "DEVICE HEALTH", isDark: isDark),
              const SizedBox(height: 12),
              controller.devices.isEmpty
                  ? _EmptyCard(message: "No devices registered", isDark: isDark)
                  : Column(
                children: controller.devices.map((device) {
                  final signal = _signalStrength[device.name] ?? 75;
                  final battery = _batteryLevel[device.name] ?? 80;
                  final ping = _lastPing[device.name] ?? "Unknown";
                  final isOnline =
                  _allOfflineOverride ? false : device.isOnline;
                  return _DeviceHealthCard(
                    device: device,
                    signal: signal,
                    battery: battery,
                    ping: ping,
                    isOnline: isOnline,
                    isDark: isDark,
                  );
                }).toList(),
              ),

              const SizedBox(height: 28),

              // Sensor Simulation
              _SectionLabel(label: "SENSOR SIMULATION", isDark: isDark),
              const SizedBox(height: 4),
              Text(
                "Force-trigger device types to test the alert pipeline",
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? const Color(0xFF7B9DBF)
                      : const Color(0xFF5A7A9F),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _SimButton(
                      label: "Trigger Door",
                      icon: Icons.door_front_door_rounded,
                      color: const Color(0xFFD32F2F),
                      isDark: isDark,
                      onTap: () =>
                          _simulateTrigger(context, controller, "door"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SimButton(
                      label: "Trigger Motion",
                      icon: Icons.motion_photos_on_rounded,
                      color: const Color(0xFFF57C00),
                      isDark: isDark,
                      onTap: () =>
                          _simulateTrigger(context, controller, "motion"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _SimButton(
                      label: "Trigger Camera",
                      icon: Icons.videocam_rounded,
                      color: const Color(0xFF7B1FA2),
                      isDark: isDark,
                      onTap: () =>
                          _simulateTrigger(context, controller, "camera"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SimButton(
                      label: "Trigger All",
                      icon: Icons.warning_amber_rounded,
                      color: const Color(0xFFD32F2F),
                      isDark: isDark,
                      onTap: () => _simulateAll(context, controller),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // System Overrides
              _SectionLabel(label: "SYSTEM OVERRIDES", isDark: isDark),
              const SizedBox(height: 12),
              _OverrideTile(
                label: "Force All Devices Offline",
                subtitle: _allOfflineOverride
                    ? "All devices showing as offline"
                    : "Devices showing real status",
                icon: Icons.wifi_off_rounded,
                color: const Color(0xFFD32F2F),
                value: _allOfflineOverride,
                isDark: isDark,
                onChanged: (val) =>
                    setState(() => _allOfflineOverride = val),
              ),
              const SizedBox(height: 10),
              _ActionTile(
                label: "Clear All Alerts",
                subtitle: "${controller.alerts.length} alerts in queue",
                icon: Icons.notifications_off_rounded,
                color: const Color(0xFFF57C00),
                isDark: isDark,
                onTap: () => _clearAlerts(context, controller),
              ),
              const SizedBox(height: 10),
              _ActionTile(
                label: "Reset All Device States",
                subtitle: "Clear all triggered devices",
                icon: Icons.restart_alt_rounded,
                color: const Color(0xFF00897B),
                isDark: isDark,
                onTap: () {
                  for (final device in controller.devices) {
                    controller.resetDevice(device);
                  }
                  _showSnack(
                      context, "All devices reset", const Color(0xFF00897B));
                },
              ),
              const SizedBox(height: 10),
              _ActionTile(
                label: "Refresh Device Health",
                subtitle: "Re-generate signal & battery data",
                icon: Icons.refresh_rounded,
                color: const Color(0xFF1565C0),
                isDark: isDark,
                onTap: () {
                  setState(() => _generateMockHealth());
                  _showSnack(context, "Health data refreshed",
                      const Color(0xFF1565C0));
                },
              ),

              const SizedBox(height: 28),

              // Connection Status
              _SectionLabel(label: "CONNECTION STATUS", isDark: isDark),
              const SizedBox(height: 12),
              _InfoCard(isDark: isDark, rows: [
                _InfoRow(label: "API Endpoint", value: "mock://mazegate.dev"),
                _InfoRow(label: "Auth Token", value: "••••••••a3f9"),
                _InfoRow(label: "Latency", value: "12ms"),
                _InfoRow(label: "Uptime", value: "99.98%"),
                _InfoRow(label: "Last Sync", value: "Just now"),
                _InfoRow(
                    label: "Mode",
                    value: "Mock / Prototype",
                    valueColor: const Color(0xFF7B1FA2)),
              ]),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _simulateTrigger(
      BuildContext context, SystemController controller, String type) {
    if (!controller.isArmed) {
      _showSnack(context, "System must be armed to trigger sensors",
          const Color(0xFFF57C00));
      return;
    }
    final matches = controller.devices
        .where((d) => d.type.toLowerCase().contains(type))
        .toList();
    if (matches.isEmpty) {
      _showSnack(
          context, "No $type devices found", const Color(0xFF757575));
      return;
    }
    for (final device in matches) {
      controller.triggerDevice(device);
    }
    _showSnack(
        context,
        "${matches.length} $type device${matches.length > 1 ? 's' : ''} triggered",
        const Color(0xFFD32F2F));
  }

  void _simulateAll(BuildContext context, SystemController controller) {
    if (!controller.isArmed) {
      _showSnack(context, "System must be armed to trigger sensors",
          const Color(0xFFF57C00));
      return;
    }
    for (final device in controller.devices) {
      controller.triggerDevice(device);
    }
    _showSnack(
        context,
        "All ${controller.devices.length} devices triggered",
        const Color(0xFFD32F2F));
  }

  void _clearAlerts(BuildContext context, SystemController controller) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor:
        isDark ? const Color(0xFF111827) : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text("Clear All Alerts",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0A0F1E),
            )),
        content: Text(
          "This will permanently clear all active alerts.",
          style: TextStyle(
            color: isDark
                ? const Color(0xFF7B9DBF)
                : const Color(0xFF5A7A9F),
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
              controller.clearAlerts();
              Navigator.pop(context);
              _showSnack(
                  context, "All alerts cleared", const Color(0xFF2E7D32));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Clear",
                style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showSnack(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
  }
}

// ─── Device Health Card ───────────────────────────────────────────────────────

class _DeviceHealthCard extends StatelessWidget {
  final dynamic device;
  final int signal;
  final int battery;
  final String ping;
  final bool isOnline;
  final bool isDark;

  const _DeviceHealthCard({
    required this.device,
    required this.signal,
    required this.battery,
    required this.ping,
    required this.isOnline,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final batteryColor = battery < 20
        ? const Color(0xFFD32F2F)
        : battery < 50
        ? const Color(0xFFF57C00)
        : const Color(0xFF2E7D32);
    final signalColor = signal < 40
        ? const Color(0xFFD32F2F)
        : signal < 70
        ? const Color(0xFFF57C00)
        : const Color(0xFF2E7D32);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isOnline
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFFD32F2F),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(device.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: isDark ? Colors.white : const Color(0xFF0A0F1E),
                    )),
              ),
              Text(
                isOnline ? "Online" : "Offline",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isOnline
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFFD32F2F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _HealthBar(
                    label: "Signal",
                    value: signal,
                    color: signalColor,
                    isDark: isDark),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _HealthBar(
                    label: "Battery",
                    value: battery,
                    color: batteryColor,
                    isDark: isDark),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Last ping: $ping  ·  ${device.type}  ·  ${device.brand}",
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

class _HealthBar extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final bool isDark;

  const _HealthBar({
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark
                      ? const Color(0xFF7B9DBF)
                      : const Color(0xFF5A7A9F),
                )),
            Text("$value%",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color,
                )),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value / 100,
            backgroundColor: isDark
                ? const Color(0xFF1F3A5F)
                : const Color(0xFFDDE3EE),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

// ─── Shared Widgets ───────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final bool isDark;
  const _SectionLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.6,
          color:
          isDark ? const Color(0xFF7B9DBF) : const Color(0xFF5A7A9F),
        ));
  }
}

class _InfoRow {
  final String label;
  final String value;
  final Color? valueColor;
  const _InfoRow(
      {required this.label, required this.value, this.valueColor});
}

class _InfoCard extends StatelessWidget {
  final bool isDark;
  final List<_InfoRow> rows;
  const _InfoCard({required this.isDark, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)
        ],
      ),
      child: Column(
        children: rows
            .map((row) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(row.label,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? const Color(0xFF7B9DBF)
                        : const Color(0xFF5A7A9F),
                  )),
              Text(row.value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: row.valueColor ??
                        (isDark
                            ? Colors.white
                            : const Color(0xFF0A0F1E)),
                  )),
            ],
          ),
        ))
            .toList(),
      ),
    );
  }
}

class _SimButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _SimButton({
    required this.label,
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
        padding:
        const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Flexible(
              child: Text(label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverrideTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool value;
  final bool isDark;
  final ValueChanged<bool> onChanged;

  const _OverrideTile({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.value,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isDark
                          ? Colors.white
                          : const Color(0xFF0A0F1E),
                    )),
                Text(subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? const Color(0xFF7B9DBF)
                          : const Color(0xFF5A7A9F),
                    )),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: color),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _ActionTile({
    required this.label,
    required this.subtitle,
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF111827) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: isDark
                            ? Colors.white
                            : const Color(0xFF0A0F1E),
                      )),
                  Text(subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? const Color(0xFF7B9DBF)
                            : const Color(0xFF5A7A9F),
                      )),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: isDark
                    ? const Color(0xFF7B9DBF)
                    : const Color(0xFF5A7A9F)),
          ],
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String message;
  final bool isDark;
  const _EmptyCard({required this.message, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(message,
            style: TextStyle(
              color: isDark
                  ? const Color(0xFF7B9DBF)
                  : const Color(0xFF5A7A9F),
            )),
      ),
    );
  }
}