import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/device_model.dart';
import '../services/system_controller.dart';
// ─── Pantheon Product Catalog ─────────────────────────────────────────────────
class PantheonProduct {
  final String name;
  final String subtitle;
  final String description;
  final String mythology;
  final IconData icon;
  final Color color;
  final String type;
  final String price;
  const PantheonProduct({
    required this.name,
    required this.subtitle,
    required this.description,
    required this.mythology,
    required this.icon,
    required this.color,
    required this.type,
    required this.price,
  });
}
const List<PantheonProduct> pantheonCatalog = [
  PantheonProduct(
    name: "Atlas",
    subtitle: "Door & Window Sensor",
    description: "Monitors every entry point in your home. Instant alerts when opened or tampered with.",
    mythology: "Named for the Titan who holds up the heavens — Atlas guards every threshold.",
    icon: Icons.door_front_door_rounded,
    color: Color(0xFF1565C0),
    type: "Door / Window Sensor",
    price: "\$49.99",
  ),
  PantheonProduct(
    name: "Argus",
    subtitle: "Motion Detector",
    description: "100-zone passive infrared detection. Never misses a thing, day or night.",
    mythology: "Argus Panoptes had 100 eyes and never slept — the perfect motion sentinel.",
    icon: Icons.motion_photos_on_rounded,
    color: Color(0xFF00897B),
    type: "Motion Sensor",
    price: "\$59.99",
  ),
  PantheonProduct(
    name: "Cerberus",
    subtitle: "Outdoor Camera",
    description: "4K weatherproof camera with night vision, two-way audio, and wide-angle lens.",
    mythology: "The three-headed guardian of the gate — Cerberus lets nothing pass unseen.",
    icon: Icons.videocam_rounded,
    color: Color(0xFF6A1B9A),
    type: "Outdoor Camera",
    price: "\$129.99",
  ),
  PantheonProduct(
    name: "Helios",
    subtitle: "Indoor Camera",
    description: "1080p indoor camera with 360° pan, auto-tracking, and privacy shutter.",
    mythology: "God of the sun — Helios illuminates every corner of your home.",
    icon: Icons.camera_indoor_rounded,
    color: Color(0xFFF57C00),
    type: "Indoor Camera",
    price: "\$99.99",
  ),
  PantheonProduct(
    name: "Ares",
    subtitle: "Siren & Alarm",
    description: "110dB siren with strobe light. Triggers instantly and alerts your neighbors.",
    mythology: "God of war — Ares announces any breach with unmistakable force.",
    icon: Icons.campaign_rounded,
    color: Color(0xFFD32F2F),
    type: "Siren / Alarm",
    price: "\$79.99",
  ),
  PantheonProduct(
    name: "Aegis",
    subtitle: "Smart Lock",
    description: "Keypad + app-controlled deadbolt. Auto-locks, guest codes, and tamper alerts.",
    mythology: "The shield of Zeus — Aegis is the ultimate symbol of protection.",
    icon: Icons.lock_rounded,
    color: Color(0xFF2E7D32),
    type: "Smart Lock",
    price: "\$149.99",
  ),
];
// ─── Add Device Screen ────────────────────────────────────────────────────────
class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});
  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}
class _AddDeviceScreenState extends State<AddDeviceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF0A0F1E) : const Color(0xFFF0F4FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
              child: Row(
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
                        color: isDark ? Colors.white : const Color(0xFF0A0F1E),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Add Device",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0A0F1E),
                          ),
                        ),
                        Text(
                          "Choose a device type to get started",
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
                ],
              ),
            ),
            // Tab bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF111827)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: const Color(0xFF1565C0),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: isDark
                      ? const Color(0xFF7B9DBF)
                      : const Color(0xFF5A7A9F),
                  labelStyle: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 13),
                  tabs: const [
                    Tab(text: "MazeGate Pantheon"),
                    Tab(text: "Third-Party"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _PantheonTab(isDark: isDark),
                  _ThirdPartyTab(isDark: isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// ─── Pantheon Tab ─────────────────────────────────────────────────────────────
class _PantheonTab extends StatelessWidget {
  final bool isDark;
  const _PantheonTab({required this.isDark});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/logo_transparent.png',
                  width: 44,
                  height: 44,
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "The Pantheon Series",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        "Premium MazeGate devices.\nSeamless setup, total protection.",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Product grid
          ...pantheonCatalog.map((product) => _PantheonCard(
            product: product,
            isDark: isDark,
          )),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
class _PantheonCard extends StatelessWidget {
  final PantheonProduct product;
  final bool isDark;
  const _PantheonCard({required this.product, required this.isDark});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top section
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: product.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(product.icon, color: product.color, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "MazeGate ${product.name}",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0A0F1E),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product.subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: product.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  product.price,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0A0F1E),
                  ),
                ),
              ],
            ),
          ),
          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              product.description,
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? const Color(0xFF7B9DBF)
                    : const Color(0xFF5A7A9F),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Mythology note
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: product.color.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.auto_awesome_rounded,
                      size: 14, color: product.color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      product.mythology,
                      style: TextStyle(
                        fontSize: 11,
                        color: product.color,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Add button
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
            child: SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: () => _showAddDialog(context, product),
                style: ElevatedButton.styleFrom(
                  backgroundColor: product.color,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Add to My System",
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _showAddDialog(BuildContext context, PantheonProduct product) {
    final locationController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (_) => _AddDeviceDialog(
        title: "MazeGate ${product.name}",
        subtitle: product.subtitle,
        icon: product.icon,
        color: product.color,
        isDark: isDark,
        locationController: locationController,
        extraFields: const [],
        onAdd: () {
          if (locationController.text.trim().isEmpty) return;
          final controller =
          Provider.of<SystemController>(context, listen: false);
          controller.addDevice(DeviceModel(
            name: "MazeGate ${product.name}",
            location: locationController.text.trim(),
            brand: "MazeGate",
            type: product.type,
            isMazeGate: true,
          ));
          Navigator.pop(context); // close dialog
          Navigator.pop(context); // back to devices screen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 10),
                  Text("MazeGate ${product.name} added!"),
                ],
              ),
              backgroundColor: const Color(0xFF2E7D32),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
            ),
          );
        },
      ),
    );
  }
}
// ─── Third-Party Tab ──────────────────────────────────────────────────────────
class _ThirdPartyTab extends StatefulWidget {
  final bool isDark;
  const _ThirdPartyTab({required this.isDark});
  @override
  State<_ThirdPartyTab> createState() => _ThirdPartyTabState();
}
class _ThirdPartyTabState extends State<_ThirdPartyTab> {
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _locationController = TextEditingController();
  String _selectedType = "Motion Sensor";
  String _selectedConnection = "Wi-Fi";
  final List<String> deviceTypes = [
    "Motion Sensor",
    "Door / Window Sensor",
    "Indoor Camera",
    "Outdoor Camera",
    "Smart Lock",
    "Siren / Alarm",
    "Smoke Detector",
    "CO Detector",
    "Doorbell Camera",
    "Other",
  ];
  final List<String> connectionTypes = [
    "Wi-Fi",
    "Zigbee",
    "Z-Wave",
    "Bluetooth",
    "Other",
  ];
  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _locationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Info banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF00897B).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF00897B).withValues(alpha: 0.3),
              ),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_rounded,
                    color: Color(0xFF00897B), size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "MazeGate supports most smart home devices. Enter your device details below to add it to your system.",
                    style: TextStyle(
                      color: Color(0xFF00897B),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildLabel("Device Name", isDark),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _nameController,
            hint: "e.g. Front Door Camera",
            icon: Icons.device_hub_rounded,
            isDark: isDark,
          ),
          const SizedBox(height: 18),
          _buildLabel("Brand", isDark),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _brandController,
            hint: "e.g. Ring, Nest, Arlo, Eufy...",
            icon: Icons.business_rounded,
            isDark: isDark,
          ),
          const SizedBox(height: 18),
          _buildLabel("Location", isDark),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _locationController,
            hint: "e.g. Front Door, Living Room...",
            icon: Icons.location_on_rounded,
            isDark: isDark,
          ),
          const SizedBox(height: 18),
          _buildLabel("Device Type", isDark),
          const SizedBox(height: 8),
          _buildDropdown(
            value: _selectedType,
            items: deviceTypes,
            icon: Icons.category_rounded,
            isDark: isDark,
            onChanged: (val) => setState(() => _selectedType = val!),
          ),
          const SizedBox(height: 18),
          _buildLabel("Connection Type", isDark),
          const SizedBox(height: 8),
          _buildDropdown(
            value: _selectedConnection,
            items: connectionTypes,
            icon: Icons.wifi_rounded,
            isDark: isDark,
            onChanged: (val) => setState(() => _selectedConnection = val!),
          ),
          const SizedBox(height: 18),
          // Compatibility check
          Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Compatibility",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: isDark ? Colors.white : const Color(0xFF0A0F1E),
                  ),
                ),
                const SizedBox(height: 12),
                _compatRow("MazeGate App Control", true, isDark),
                _compatRow("Real-time Alerts", true, isDark),
                _compatRow("Arm / Disarm Integration", true, isDark),
                _compatRow(
                    "Pantheon Series Sync", false, isDark),
                _compatRow(
                    "Native MazeGate Firmware", false, isDark),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _addThirdPartyDevice,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Add Device",
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
  void _addThirdPartyDevice() {
    if (_nameController.text.trim().isEmpty ||
        _brandController.text.trim().isEmpty ||
        _locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 18),
              SizedBox(width: 10),
              Text("Please fill in all fields"),
            ],
          ),
          backgroundColor: const Color(0xFFB00020),
          behavior: SnackBarBehavior.floating,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }
    final controller =
    Provider.of<SystemController>(context, listen: false);
    controller.addDevice(DeviceModel(
      name: _nameController.text.trim(),
      location: _locationController.text.trim(),
      brand: _brandController.text.trim(),
      type: _selectedType,
      isMazeGate: false,
    ));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Text("${_nameController.text.trim()} added!"),
          ],
        ),
        backgroundColor: const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
  Widget _compatRow(String label, bool supported, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            supported
                ? Icons.check_circle_rounded
                : Icons.cancel_rounded,
            size: 16,
            color: supported
                ? const Color(0xFF2E7D32)
                : const Color(0xFF757575),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? (supported ? Colors.white : const Color(0xFF7B9DBF))
                  : (supported
                  ? const Color(0xFF0A0F1E)
                  : const Color(0xFF9E9E9E)),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildLabel(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color:
        isDark ? const Color(0xFF9BB8D4) : const Color(0xFF5A7A9F),
      ),
    );
  }
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool isDark,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(
        color: isDark ? Colors.white : const Color(0xFF0A0F1E),
        fontSize: 15,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark
              ? Colors.white.withValues(alpha: 0.2)
              : const Color(0xFF9E9E9E),
          fontSize: 14,
        ),
        prefixIcon: Icon(icon,
            color: const Color(0xFF7B9DBF), size: 20),
        filled: true,
        fillColor: isDark
            ? const Color(0xFF1A2235)
            : const Color(0xFFF5F7FA),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: Color(0xFF1565C0), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark
                ? const Color(0xFF1F3A5F).withValues(alpha: 0.4)
                : const Color(0xFFDDE3EE),
            width: 1,
          ),
        ),
      ),
    );
  }
  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required IconData icon,
    required bool isDark,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2235) : const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? const Color(0xFF1F3A5F).withValues(alpha: 0.4)
              : const Color(0xFFDDE3EE),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF7B9DBF), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              underline: const SizedBox(),
              dropdownColor:
              isDark ? const Color(0xFF111827) : Colors.white,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF0A0F1E),
                fontSize: 15,
              ),
              items: items
                  .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
// ─── Add Device Dialog ────────────────────────────────────────────────────────
class _AddDeviceDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isDark;
  final TextEditingController locationController;
  final List<Widget> extraFields;
  final VoidCallback onAdd;
  const _AddDeviceDialog({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isDark,
    required this.locationController,
    required this.extraFields,
    required this.onAdd,
  });
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: isDark ? const Color(0xFF111827) : Colors.white,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0A0F1E),
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "Location",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? const Color(0xFF9BB8D4)
                    : const Color(0xFF5A7A9F),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: locationController,
              autofocus: true,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF0A0F1E),
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: "e.g. Front Door, Garage...",
                hintStyle: TextStyle(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.2)
                      : const Color(0xFF9E9E9E),
                ),
                prefixIcon: const Icon(Icons.location_on_rounded,
                    color: Color(0xFF7B9DBF), size: 20),
                filled: true,
                fillColor: isDark
                    ? const Color(0xFF1A2235)
                    : const Color(0xFFF5F7FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: color, width: 1.5),
                ),
              ),
            ),
            ...extraFields,
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark
                          ? const Color(0xFF7B9DBF)
                          : const Color(0xFF5A7A9F),
                      side: BorderSide(
                        color: isDark
                            ? const Color(0xFF1F3A5F)
                            : const Color(0xFFDDE3EE),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Cancel",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAdd,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Add Device",
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}