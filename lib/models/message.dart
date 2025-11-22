class Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? imagePath;
  final String? riskLevel;

  Message({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.imagePath,
    this.riskLevel,
  });
}