import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../services/system_controller.dart';
import 'login_screen.dart';
import 'event_log_screen.dart';
import 'about_screen.dart';

class SettingsScreen extends StatelessWidget {
  final UserType userType;

  const SettingsScreen({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<SystemController>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isDev = userType == UserType.dev;

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
              const SizedBox(height: 4),
              Text(
                "Settings",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF0A0F1E),
                ),
              ),

              const SizedBox(height: 28),

              // Profile card
              _ProfileCard(isDark: isDark, isDev: isDev),

              const SizedBox(height: 24),

              // Appearance section
              _SectionLabel(label: "APPEARANCE", isDark: isDark),
              const SizedBox(height: 12),

              _SettingsTile(
                isDark: isDark,
                icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                iconColor: const Color(0xFF7B1FA2),
                title: "Dark Mode",
                subtitle: isDark ? "Dark theme enabled" : "Light theme enabled",
                trailing: Switch(
                  value: controller.isDarkMode,
                  onChanged: controller.toggleDarkMode,
                  activeColor: const Color(0xFF1565C0),
                ),
              ),

              const SizedBox(height: 24),

              // System section
              _SectionLabel(label: "SYSTEM", isDark: isDark),
              const SizedBox(height: 12),

              _SettingsTile(
                isDark: isDark,
                icon: Icons.info_outline_rounded,
                iconColor: const Color(0xFF1565C0),
                title: "App Version",
                subtitle: "MazeGate v1.0.0 — Prototype",
              ),

              const SizedBox(height: 8),

              _SettingsTile(
                isDark: isDark,
                icon: Icons.security_rounded,
                iconColor: const Color(0xFF2E7D32),
                title: "Security Protocol",
                subtitle: "AES-256 encrypted · Mock demo mode",
              ),

              const SizedBox(height: 8),

              _SettingsTile(
                isDark: isDark,
                icon: Icons.notifications_rounded,
                iconColor: const Color(0xFFF57C00),
                title: "Notifications",
                subtitle: "Push alerts enabled",
              ),

              const SizedBox(height: 8),

              _SettingsTile(
                isDark: isDark,
                icon: Icons.history_rounded,
                iconColor: const Color(0xFF1565C0),
                title: "Event Log",
                subtitle: "View full system activity history",
                onTap: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const EventLogScreen(),
                    transitionsBuilder: (_, animation, __, child) =>
                        FadeTransition(opacity: animation, child: child),
                    transitionDuration: const Duration(milliseconds: 300),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              _SettingsTile(
                isDark: isDark,
                icon: Icons.info_outline_rounded,
                iconColor: const Color(0xFF7B1FA2),
                title: "About MazeGate",
                subtitle: "Mission, products, and contact",
                onTap: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const AboutScreen(),
                    transitionsBuilder: (_, animation, __, child) =>
                        FadeTransition(opacity: animation, child: child),
                    transitionDuration: const Duration(milliseconds: 300),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Account section
              _SectionLabel(label: "ACCOUNT", isDark: isDark),
              const SizedBox(height: 12),

              _SettingsTile(
                isDark: isDark,
                icon: Icons.logout_rounded,
                iconColor: const Color(0xFFD32F2F),
                title: "Sign Out",
                subtitle: "Return to login screen",
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => _LogoutDialog(isDark: isDark),
                  );
                },
              ),

              const SizedBox(height: 32),

              // Footer
              Center(
                child: Text(
                  "MazeGate · Smart Security Platform\nPrototype Build — Capstone 2025",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.7,
                    color: isDark
                        ? const Color(0xFF7B9DBF).withValues(alpha: 0.5)
                        : const Color(0xFF5A7A9F).withValues(alpha: 0.5),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Profile Card ─────────────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  final bool isDark;
  final bool isDev;
  const _ProfileCard({required this.isDark, required this.isDev});

  @override
  Widget build(BuildContext context) {
    final email = isDev ? "JDangerfield@mazegate.com" : "customer@mazegate.com";
    final role = isDev ? "Developer" : "Customer";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDev
              ? [const Color(0xFF6A1B9A), const Color(0xFF4A148C)]
              : [const Color(0xFF1565C0), const Color(0xFF0D47A1)],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: (isDev ? const Color(0xFF6A1B9A) : const Color(0xFF1565C0))
                .withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              isDev ? Icons.developer_mode_rounded : Icons.person_rounded,
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
                  isDev ? "Developer Account" : "MazeGate User",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Customer",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final bool isDark;
  const _SectionLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.6,
        color: isDark ? const Color(0xFF7B9DBF) : const Color(0xFF5A7A9F),
      ),
    );
  }
}

// ─── Settings Tile ────────────────────────────────────────────────────────────

class _SettingsTile extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.isDark,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
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
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: isDark ? Colors.white : const Color(0xFF0A0F1E),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
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
            if (trailing != null) trailing!,
            if (trailing == null && onTap != null)
              Icon(
                Icons.chevron_right_rounded,
                color: isDark
                    ? const Color(0xFF7B9DBF)
                    : const Color(0xFF5A7A9F),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Logout Dialog ────────────────────────────────────────────────────────────

class _LogoutDialog extends StatelessWidget {
  final bool isDark;
  const _LogoutDialog({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: isDark ? const Color(0xFF111827) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        "Sign Out",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : const Color(0xFF0A0F1E),
        ),
      ),
      content: Text(
        "Are you sure you want to sign out of MazeGate?",
        style: TextStyle(
          color: isDark ? const Color(0xFF7B9DBF) : const Color(0xFF5A7A9F),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Cancel",
            style: TextStyle(
              color: isDark ? const Color(0xFF7B9DBF) : const Color(0xFF5A7A9F),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const LoginScreen(),
                transitionsBuilder: (_, animation, __, child) =>
                    FadeTransition(opacity: animation, child: child),
                transitionDuration: const Duration(milliseconds: 400),
              ),
                  (route) => false,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD32F2F),
            foregroundColor: Colors.white,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text(
            "Sign Out",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}