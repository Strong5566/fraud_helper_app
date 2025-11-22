import 'package:flutter/services.dart';
import 'dart:convert';

class ScoreService {
  static final ScoreService _instance = ScoreService._internal();
  factory ScoreService() => _instance;
  ScoreService._internal();

  int _currentScore = 50; // 初始積分50
  List<Map<String, dynamic>> _levelData = [];

  int get currentScore => _currentScore;

  Future<void> loadLevelData() async {
    if (_levelData.isNotEmpty) return;
    
    try {
      final csvData = await rootBundle.loadString('assets/score_table.csv');
      final lines = csvData.split('\n');
      
      for (int i = 1; i < lines.length; i++) {
        final parts = lines[i].split(',');
        if (parts.length >= 4) {
          final scoreRange = parts[2].trim();
          final rangeParts = scoreRange.split('～');
          
          int minScore = 0;
          int maxScore = 999999;
          
          if (rangeParts.length == 2) {
            minScore = int.tryParse(rangeParts[0]) ?? 0;
            final maxPart = rangeParts[1];
            if (maxPart.contains('以上')) {
              maxScore = 999999;
            } else {
              maxScore = int.tryParse(maxPart) ?? 999999;
            }
          }
          
          _levelData.add({
            'level': i,
            'name': parts[1].trim(),
            'minScore': minScore,
            'maxScore': maxScore,
            'title': parts[3].trim(),
          });
        }
      }
    } catch (e) {
      print('載入等級資料失敗: $e');
    }
  }

  Map<String, dynamic> getCurrentLevel() {
    for (var level in _levelData) {
      if (_currentScore >= level['minScore'] && _currentScore <= level['maxScore']) {
        return level;
      }
    }
    return _levelData.isNotEmpty ? _levelData.first : {};
  }

  Map<String, dynamic>? getNextLevel() {
    final currentLevel = getCurrentLevel();
    final currentLevelNum = currentLevel['level'] ?? 1;
    
    for (var level in _levelData) {
      if (level['level'] == currentLevelNum + 1) {
        return level;
      }
    }
    return null;
  }

  Future<Map<String, dynamic>> addScore(int points) async {
    final oldLevel = getCurrentLevel();
    _currentScore += points;
    final newLevel = getCurrentLevel();
    
    final result = {
      'oldScore': _currentScore - points,
      'newScore': _currentScore,
      'pointsAdded': points,
      'levelUp': oldLevel['level'] != newLevel['level'],
      'oldLevel': oldLevel,
      'newLevel': newLevel,
      'newAchievement': null,
    };

    // 檢查是否獲得新徽章
    if (result['levelUp'] != null) {
      result['newAchievement'] = _getAchievementForLevel(newLevel['level']);
    }

    return result;
  }

  String? _getAchievementForLevel(int level) {
    switch (level) {
      case 2: return '異常紀錄者';
      case 3: return '警惕之眼';
      case 4: return '稽核助理';
      case 5: return '資訊分析員';
      case 6: return '真相追索者';
      default: return null;
    }
  }

  List<String> getUnlockedAchievements() {
    final currentLevel = getCurrentLevel()['level'] ?? 1;
    List<String> achievements = ['新手守護者']; // 預設徽章
    
    if (currentLevel >= 2) achievements.add('異常紀錄者');
    if (currentLevel >= 3) achievements.add('警惕之眼');
    if (currentLevel >= 4) achievements.add('稽核助理');
    if (currentLevel >= 5) achievements.add('資訊分析員');
    if (currentLevel >= 6) achievements.add('真相追索者');
    
    return achievements;
  }
}