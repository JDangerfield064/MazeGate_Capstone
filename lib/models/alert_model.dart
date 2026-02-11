class AlertModel {
  final String title;
  final String location;
  final DateTime timestamp;
  final bool isCritical;

  AlertModel({
    required this.title,
    required this.location,
    required this.timestamp,
    this.isCritical = false,
  });
}