import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../services/system_controller.dart';
import 'alert_screen.dart';
import 'dev_screen.dart';
import 'device_screen.dart';
import 'home_dashboard.dart';
import 'settings_screen.dart';

class MainNavigation extends StatefulWidget {
  final UserType userType;

  const MainNavigation({
    super.key,
    required this.userType,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = _buildScreens();

    final alertCount = Provider.of<SystemController>(context).alerts.length;

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: _buildNavItems(alertCount),
      ),
    );
  }

  List<Widget> _buildScreens() {
    final baseScreens = [
      HomeDashboard(
        onNavigate: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      const AlertsScreen(),
      DevicesScreen(),
    ];

    if (widget.userType == UserType.dev) {
      return [
        ...baseScreens,
        const DeveloperToolsScreen(),
        SettingsScreen(userType: widget.userType),
      ];
    }
    return [
      ...baseScreens,
      SettingsScreen(userType: widget.userType),
    ];
  }
  List<BottomNavigationBarItem> _buildNavItems(int alertCount) {
    final alertIcon = alertCount > 0
        ? Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.notifications),
        Positioned(
          right: -6,
          top: -4,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Color(0xFFD32F2F),
              shape: BoxShape.circle,
            ),
            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
            child: Text(
              alertCount > 9 ? '9+' : '$alertCount',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    )
        : const Icon(Icons.notifications);

    final baseItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: "Home",
      ),
      BottomNavigationBarItem(
        icon: alertIcon,
        label: "Alerts",
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.devices),
        label: "Devices",
      ),
    ];

    if (widget.userType == UserType.dev) {
      return [
        ...baseItems,
        const BottomNavigationBarItem(
          icon: Icon(Icons.developer_mode),
          label: "Dev Tools",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Settings",
        ),
      ];
    }
    return [
      ...baseItems,
      const BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: "Settings",
      ),
    ];
  }
}