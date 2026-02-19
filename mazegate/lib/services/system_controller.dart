import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/device_model.dart';
import '../models/user_model.dart';
import '../models/alert_model.dart';

// ─── Event Log Entry ──────────────────────────────────────────────────────────

class EventLogEntry {
  final String message;
  final DateTime timestamp;
  final EventType type;

  EventLogEntry({
    required this.message,
    required this.timestamp,
    required this.type,
  });
}

enum EventType {
  armed,
  disarmed,
  deviceTriggered,
  deviceAdded,
  deviceRemoved,
  login,
  logout
}

// ─── System Controller ────────────────────────────────────────────────────────

class SystemController extends ChangeNotifier {
  bool _isDarkMode = false;
  String? _currentUserEmail;

  bool get isDarkMode => _isDarkMode;
  String? get currentUserEmail => _currentUserEmail;
  String get currentUserName {
    final user = _registeredUsers.where((u) => u.email == _currentUserEmail).firstOrNull;
    return user?.name.isNotEmpty == true ? user!.name : _currentUserEmail?.split('@').first ?? '';
  }

  final Map<String, bool> _armedStates = {};
  bool get isArmed => _armedStates[_currentUserEmail ?? ''] ?? false;

  // Default devices — only used if nothing is saved yet
  final List<DeviceModel> _devices = [];
  final List<AlertModel> _alerts = [];
  final List<EventLogEntry> _eventLog = [];

  List<DeviceModel> get devices => _devices;
  List<AlertModel> get alerts => _alerts;
  List<EventLogEntry> get eventLog => _eventLog;

  // Built-in accounts — always present
  static const List<Map<String, String>> _builtInUsers = [
    {'email': 'JDangerfield@mazegate.com', 'password': 'dev123', 'type': 'dev', 'name': 'J. Dangerfield'},
    {'email': 'customer@mazegate.com', 'password': 'cust123', 'type': 'customer', 'name': 'Customer'},
  ];

  final List<UserModel> _registeredUsers = [];
  List<UserModel> get registeredUsers => _registeredUsers;

  // ─── Session ────────────────────────────────────────────────────────────────

  void login(String email) {
    _currentUserEmail = email;
    _addEvent("Signed in as $email", EventType.login);
    notifyListeners();
  }

  void logout() {
    if (_currentUserEmail != null) {
      _addEvent("Signed out of $_currentUserEmail", EventType.logout);
    }
    _currentUserEmail = null;
    notifyListeners();
  }

  // ─── Persistence ────────────────────────────────────────────────────────────

  Future<void> loadSystemState() async {
    final prefs = await SharedPreferences.getInstance();

    // Dark mode
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;

    // Armed states
    for (final key in prefs.getKeys()) {
      if (key.startsWith('armed_')) {
        final email = key.replaceFirst('armed_', '');
        _armedStates[email] = prefs.getBool(key) ?? false;
      }
    }

    // Devices — load saved or fall back to defaults
    final devicesJson = prefs.getString('devices');
    if (devicesJson != null) {
      final List decoded = jsonDecode(devicesJson);
      _devices.clear();
      _devices.addAll(decoded.map((d) => DeviceModel.fromJson(d)));
    } else {
      // First run — load defaults
      _devices.addAll([
        DeviceModel(
            name: "MazeGate Atlas",
            location: "Front Door",
            brand: "MazeGate",
            type: "Door / Window Sensor",
            isMazeGate: true),
        DeviceModel(
            name: "MazeGate Argus",
            location: "Living Room",
            brand: "MazeGate",
            type: "Motion Sensor",
            isMazeGate: true),
        DeviceModel(
            name: "MazeGate Cerberus",
            location: "Garage",
            brand: "MazeGate",
            type: "Outdoor Camera",
            isMazeGate: true),
      ]);
      await _saveDevices();
    }

    // Users — always start with built-ins, then add any saved signups
    _registeredUsers.clear();
    _registeredUsers.addAll(
      _builtInUsers.map((u) => UserModel(
        email: u['email']!,
        password: u['password']!,
        type: u['type'] == 'dev' ? UserType.dev : UserType.customer,
        name: u['name'] ?? '',
      )),
    );

    final usersJson = prefs.getString('registered_users');
    if (usersJson != null) {
      final List decoded = jsonDecode(usersJson);
      for (final u in decoded.map((d) => UserModel.fromJson(d))) {
        // Don't duplicate built-ins
        if (!_registeredUsers
            .any((existing) => existing.email == u.email)) {
          _registeredUsers.add(u);
        }
      }
    }
  }

  Future<void> _saveDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_devices.map((d) => d.toJson()).toList());
    await prefs.setString('devices', encoded);
  }

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    // Only save non-built-in users (signups)
    final signups = _registeredUsers
        .where((u) => !_builtInUsers.any((b) => b['email'] == u.email))
        .toList();
    final encoded = jsonEncode(signups.map((u) => u.toJson()).toList());
    await prefs.setString('registered_users', encoded);
  }

  Future<void> _saveArmedState() async {
    if (_currentUserEmail == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('armed_$_currentUserEmail', isArmed);
  }

  // ─── System Arm/Disarm ───────────────────────────────────────────────────────

  void toggleSystem() {
    final email = _currentUserEmail ?? '';
    _armedStates[email] = !isArmed;
    _saveArmedState();

    if (isArmed) {
      _addEvent("System armed by ${_currentUserEmail ?? 'unknown'}",
          EventType.armed);
    } else {
      _addEvent("System disarmed by ${_currentUserEmail ?? 'unknown'}",
          EventType.disarmed);
    }

    notifyListeners();
  }

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    SharedPreferences.getInstance()
        .then((p) => p.setBool('isDarkMode', value));
    notifyListeners();
  }

  // ─── Devices ────────────────────────────────────────────────────────────────

  void triggerDevice(DeviceModel device) {
    if (!isArmed) return;
    device.isTriggered = true;
    _alerts.insert(
      0,
      AlertModel(
        title: "${device.name} Triggered",
        description: "Activity detected at ${device.location}",
        timestamp: DateTime.now(),
      ),
    );
    _addEvent("${device.name} triggered at ${device.location}",
        EventType.deviceTriggered);
    notifyListeners();
  }

  void resetDevice(DeviceModel device) {
    device.isTriggered = false;
    notifyListeners();
  }

  void addDevice(DeviceModel device) {
    _devices.add(device);
    _saveDevices();
    _addEvent("${device.name} added to system", EventType.deviceAdded);
    notifyListeners();
  }

  void removeDevice(DeviceModel device) {
    _devices.remove(device);
    _saveDevices();
    _addEvent("${device.name} removed from system", EventType.deviceRemoved);
    notifyListeners();
  }

  // ─── Alerts ─────────────────────────────────────────────────────────────────

  void clearAlerts() {
    _alerts.clear();
    notifyListeners();
  }

  void dismissAlert(int index) {
    if (index >= 0 && index < _alerts.length) {
      _alerts.removeAt(index);
      notifyListeners();
    }
  }

  // ─── Event Log ──────────────────────────────────────────────────────────────

  void _addEvent(String message, EventType type) {
    _eventLog.insert(
      0,
      EventLogEntry(
        message: message,
        timestamp: DateTime.now(),
        type: type,
      ),
    );
  }

  void clearEventLog() {
    _eventLog.clear();
    notifyListeners();
  }

  // ─── Users ──────────────────────────────────────────────────────────────────

  void addUser(UserModel user) {
    _registeredUsers.add(user);
    _saveUsers();
    notifyListeners();
  }

  bool userExists(String email) {
    return _registeredUsers
        .any((u) => u.email.toLowerCase() == email.toLowerCase());
  }
}