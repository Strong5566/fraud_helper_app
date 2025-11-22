class Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? imagePath;

  Message({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.imagePath,
  });
}