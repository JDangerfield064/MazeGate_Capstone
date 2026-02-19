import 'package:flutter/material.dart';
import 'add_device_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  Text(
                    "About MazeGate",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color:
                      isDark ? Colors.white : const Color(0xFF0A0F1E),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Logo + tagline hero
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0D47A1), Color(0xFF1565C0)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo_transparent.png',
                      width: 72,
                      height: 72,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "MazeGate",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Protected by the gods.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Version 1.0.0 · Prototype",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Mission
              _SectionTitle(label: "OUR MISSION", isDark: isDark),
              const SizedBox(height: 12),
              _Card(
                isDark: isDark,
                child: Text(
                  "MazeGate was built on a simple belief: home security should be smart, seamless, and accessible to everyone. We combine premium hardware with an intelligent app to give you complete visibility and control over your home — from anywhere in the world.",
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? const Color(0xFF9BB8D4)
                        : const Color(0xFF5A7A9F),
                    height: 1.7,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Pantheon Series
              _SectionTitle(label: "THE PANTHEON SERIES", isDark: isDark),
              const SizedBox(height: 4),
              Text(
                "Our flagship product lineup — named for the gods who never sleep.",
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? const Color(0xFF7B9DBF)
                      : const Color(0xFF5A7A9F),
                ),
              ),
              const SizedBox(height: 12),

              ...pantheonCatalog.map((product) => _ProductRow(
                product: product,
                isDark: isDark,
              )),

              const SizedBox(height: 24),

              // How it works
              _SectionTitle(label: "HOW IT WORKS", isDark: isDark),
              const SizedBox(height: 12),
              _Card(
                isDark: isDark,
                child: Column(
                  children: [
                    _StepRow(
                      step: "1",
                      title: "Browse & Purchase",
                      description:
                      "Shop the Pantheon Series on mazegate.com and have devices shipped to your door.",
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),
                    _StepRow(
                      step: "2",
                      title: "Add to Your System",
                      description:
                      "Native MazeGate devices connect instantly. Third-party devices can be added manually.",
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),
                    _StepRow(
                      step: "3",
                      title: "Arm & Monitor",
                      description:
                      "Arm your system from anywhere. Get instant alerts when sensors detect activity.",
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Why MazeGate
              _SectionTitle(label: "WHY MAZEGATE", isDark: isDark),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ValueCard(
                      icon: Icons.bolt_rounded,
                      label: "Instant Alerts",
                      color: const Color(0xFFF57C00),
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ValueCard(
                      icon: Icons.shield_rounded,
                      label: "Always Secure",
                      color: const Color(0xFF2E7D32),
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _ValueCard(
                      icon: Icons.devices_rounded,
                      label: "Any Device",
                      color: const Color(0xFF1565C0),
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ValueCard(
                      icon: Icons.language_rounded,
                      label: "Web + App",
                      color: const Color(0xFF7B1FA2),
                      isDark: isDark,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Contact
              _SectionTitle(label: "CONTACT", isDark: isDark),
              const SizedBox(height: 12),
              _Card(
                isDark: isDark,
                child: Column(
                  children: [
                    _ContactRow(
                      icon: Icons.language_rounded,
                      label: "Website",
                      value: "mazegate.com",
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),
                    _ContactRow(
                      icon: Icons.email_rounded,
                      label: "Support",
                      value: "support@mazegate.com",
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),
                    _ContactRow(
                      icon: Icons.location_on_rounded,
                      label: "HQ",
                      value: "Salt Lake City, UT",
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Text(
                "© 2026 MazeGate Security. All rights reserved.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark
                      ? const Color(0xFF7B9DBF)
                      : const Color(0xFF5A7A9F),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Widgets ──────────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String label;
  final bool isDark;
  const _SectionTitle({required this.label, required this.isDark});

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

class _Card extends StatelessWidget {
  final bool isDark;
  final Widget child;
  const _Card({required this.isDark, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ProductRow extends StatelessWidget {
  final PantheonProduct product;
  final bool isDark;
  const _ProductRow({required this.product, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(14),
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
              color: product.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(product.icon, color: product.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "MazeGate ${product.name}",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color:
                    isDark ? Colors.white : const Color(0xFF0A0F1E),
                  ),
                ),
                Text(
                  product.subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: product.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            product.price,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0A0F1E),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final String step;
  final String title;
  final String description;
  final bool isDark;

  const _StepRow({
    required this.step,
    required this.title,
    required this.description,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: Color(0xFF1565C0),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              step,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: isDark ? Colors.white : const Color(0xFF0A0F1E),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? const Color(0xFF7B9DBF)
                      : const Color(0xFF5A7A9F),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ValueCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;

  const _ValueCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0A0F1E),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF1565C0)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark
                    ? const Color(0xFF7B9DBF)
                    : const Color(0xFF5A7A9F),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF0A0F1E),
              ),
            ),
          ],
        ),
      ],
    );
  }
}