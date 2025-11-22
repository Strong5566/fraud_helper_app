import 'package:flutter/foundation.dart';

class AchievementNotifier extends ChangeNotifier {
  static final AchievementNotifier _instance = AchievementNotifier._internal();
  factory AchievementNotifier() => _instance;
  AchievementNotifier._internal();

  void refreshAchievements() {
    notifyListeners();
  }
}