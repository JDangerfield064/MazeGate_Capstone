import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/system_controller.dart';

class EventLogScreen extends StatelessWidget {
  const EventLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<SystemController>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF0A0F1E) : const Color(0xFFF0F4FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF111827)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.07),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 16,
                        color: isDark
                            ? Colors.white
                            : const Color(0xFF0A0F1E),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "MAZEGATE",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.6,
                            color: isDark
                                ? const Color(0xFF7B9DBF)
                                : const Color(0xFF5A7A9F),
                          ),
                        ),
                        Text(
                          "Event Log",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0A0F1E),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (controller.eventLog.isNotEmpty)
                    GestureDetector(
                      onTap: () => _confirmClear(context, controller, isDark),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD32F2F)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "Clear",
                          style: TextStyle(
                            color: Color(0xFFD32F2F),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 24),

              // Stats row
              if (controller.eventLog.isNotEmpty) ...[
                Row(
                  children: [
                    _StatChip(
                      label: "Total Events",
                      value: "${controller.eventLog.length}",
                      color: const Color(0xFF1565C0),
                      isDark: isDark,
                    ),
                    const SizedBox(width: 10),
                    _StatChip(
                      label: "Triggers",
                      value: "${controller.eventLog.where((e) => e.type == EventType.deviceTriggered).length}",
                      color: const Color(0xFFD32F2F),
                      isDark: isDark,
                    ),
                    const SizedBox(width: 10),
                    _StatChip(
                      label: "Arm/Disarm",
                      value: "${controller.eventLog.where((e) => e.type == EventType.armed || e.type == EventType.disarmed).length}",
                      color: const Color(0xFF2E7D32),
                      isDark: isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],

              // Event list
              Expanded(
                child: controller.eventLog.isEmpty
                    ? _EmptyState(isDark: isDark)
                    : ListView.builder(
                  itemCount: controller.eventLog.length,
                  itemBuilder: (context, index) {
                    return _EventRow(
                      entry: controller.eventLog[index],
                      isDark: isDark,
                      isFirst: index == 0,
                      isLast:
                      index == controller.eventLog.length - 1,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmClear(
      BuildContext context, SystemController controller, bool isDark) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF111827) : Colors.white,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Clear Event Log",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0A0F1E),
          ),
        ),
        content: Text(
          "This will permanently delete all event history. Are you sure?",
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
              controller.clearEventLog();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Clear All",
                style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// ─── Event Row ────────────────────────────────────────────────────────────────

class _EventRow extends StatelessWidget {
  final EventLogEntry entry;
  final bool isDark;
  final bool isFirst;
  final bool isLast;

  const _EventRow({
    required this.entry,
    required this.isDark,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final color = _colorForType(entry.type);
    final icon = _iconForType(entry.type);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline column
        Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isDark
                    ? const Color(0xFF1F3A5F)
                    : const Color(0xFFDDE3EE),
              ),
          ],
        ),

        const SizedBox(width: 14),

        // Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111827) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: isFirst
                    ? Border.all(
                    color: color.withValues(alpha: 0.3), width: 1)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.message,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isFirst
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0A0F1E),
                          ),
                        ),
                      ),
                      if (isFirst)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            "LATEST",
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 11,
                        color: isDark
                            ? const Color(0xFF7B9DBF)
                            : const Color(0xFF5A7A9F),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTimestamp(entry.timestamp),
                        style: TextStyle(
                          fontSize: 11,
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
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    return "$h:$m:$s  ·  $month/$day/${dt.year}";
  }

  Color _colorForType(EventType type) {
    switch (type) {
      case EventType.armed:
        return const Color(0xFF7B1FA2);
      case EventType.disarmed:
        return const Color(0xFF2E7D32);
      case EventType.deviceTriggered:
        return const Color(0xFFD32F2F);
      case EventType.deviceAdded:
        return const Color(0xFF1565C0);
      case EventType.deviceRemoved:
        return const Color(0xFF757575);
      case EventType.login:
        return const Color(0xFF00897B);
      case EventType.logout:
        return const Color(0xFF5A7A9F);
    }
  }

  IconData _iconForType(EventType type) {
    switch (type) {
      case EventType.armed:
        return Icons.lock_rounded;
      case EventType.disarmed:
        return Icons.lock_open_rounded;
      case EventType.deviceTriggered:
        return Icons.warning_amber_rounded;
      case EventType.deviceAdded:
        return Icons.add_circle_rounded;
      case EventType.deviceRemoved:
        return Icons.remove_circle_rounded;
      case EventType.login:
        return Icons.login_rounded;
      case EventType.logout:
        return Icons.logout_rounded;
    }
  }
}

// ─── Stat Chip ────────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding:
        const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF111827) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
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

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.history_rounded,
                size: 34, color: Color(0xFF1565C0)),
          ),
          const SizedBox(height: 18),
          Text(
            "No Events Yet",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0A0F1E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "System activity will appear here.\nArm your system to get started.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? const Color(0xFF7B9DBF)
                  : const Color(0xFF5A7A9F),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}