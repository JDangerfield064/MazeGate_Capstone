class DeviceModel {
  final String name;
  final String location;
  final bool isOnline;
  final bool isTriggered;
  DeviceModel({
    required this.name,
    required this.location,
    this.isOnline = true,
    this.isTriggered = false,
  });
}