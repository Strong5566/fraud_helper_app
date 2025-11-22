import 'package:flutter/material.dart';
import 'dart:io';
import '../models/message.dart';
import '../screens/report_webview_screen.dart';
import '../utils/app_images.dart';
import '../services/score_service.dart';
import '../services/achievement_notifier.dart';
import '../widgets/level_up_animation.dart';

class MessageBubble extends StatefulWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  final ScoreService _scoreService = ScoreService();

  Future<void> _handleReport() async {
    await _scoreService.loadLevelData();
    final result = await _scoreService.addScore(50);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已提交檢舉！獲得 ${result['pointsAdded']} 積分'),
        backgroundColor: Colors.green,
      ),
    );
    
    if (result['levelUp']) {
      _showLevelUpAnimation(result);
    }
  }

  void _showLevelUpAnimation(Map<String, dynamic> levelUpData) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LevelUpAnimation(
        levelUpData: levelUpData,
        onComplete: () {
          Navigator.of(context).pop();
          AchievementNotifier().refreshAchievements();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: widget.message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.message.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage(AppImages.robotAvatar),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: widget.message.isUser ? Colors.blue : const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.message.riskLevel == 'high') ...[
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        border: Border.all(color: Colors.red, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '風險等級：高',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                  if (widget.message.imagePath != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(widget.message.imagePath!),
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (widget.message.text.isNotEmpty) const SizedBox(height: 8),
                  ],
                  if (widget.message.text.isNotEmpty)
                    Text(
                      widget.message.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  if (widget.message.riskLevel == 'high') ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _handleReport,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('一鍵檢舉'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ReportWebViewScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('協助報案'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (widget.message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage(AppImages.userAvatar),
            ),
          ],
        ],
      ),
    );
  }
}