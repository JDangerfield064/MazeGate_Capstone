class DeviceModel {
  final String name;
  final String location;
  final String brand;
  final String type;
  final bool isMazeGate;
  bool isOnline;
  bool isTriggered;
  DeviceModel({
    required this.name,
    required this.location,
    this.brand = "MazeGate",
    this.type = "Sensor",
    this.isMazeGate = true,
    this.isOnline = true,
    this.isTriggered = false,
  });
  Map<String, dynamic> toJson() => {
    'name': name,
    'location': location,
    'brand': brand,
    'type': type,
    'isMazeGate': isMazeGate,
    'isOnline': isOnline,
    'isTriggered': isTriggered,
  };
  factory DeviceModel.fromJson(Map<String, dynamic> json) => DeviceModel(
    name: json['name'] ?? '',
    location: json['location'] ?? '',
    brand: json['brand'] ?? 'MazeGate',
    type: json['type'] ?? 'Sensor',
    isMazeGate: json['isMazeGate'] ?? true,
    isOnline: json['isOnline'] ?? true,
    isTriggered: json['isTriggered'] ?? false,
  );
}