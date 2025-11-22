import 'package:flutter/material.dart';
import '../services/score_service.dart';
import '../services/achievement_notifier.dart';
import '../utils/app_images.dart';

class AchievementScreen extends StatefulWidget {
  const AchievementScreen({Key? key}) : super(key: key);

  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> with AutomaticKeepAliveClientMixin {
  final ScoreService _scoreService = ScoreService();
  final AchievementNotifier _notifier = AchievementNotifier();
  Map<String, dynamic> _currentLevel = {};
  Map<String, dynamic>? _nextLevel;
  List<String> _unlockedAchievements = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _notifier.addListener(_loadData);
  }

  @override
  void dispose() {
    _notifier.removeListener(_loadData);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  void _loadData() async {
    await _scoreService.loadLevelData();
    if (mounted) {
      setState(() {
        _currentLevel = _scoreService.getCurrentLevel();
        _nextLevel = _scoreService.getNextLevel();
        _unlockedAchievements = _scoreService.getUnlockedAchievements();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_currentLevel.isEmpty) {
      return const Scaffold(
        backgroundColor: Color(0xFF1A1A1A),
        body: Center(
          child: CircularProgressIndicator(color: Colors.blue),
        ),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text('我的反詐戰績', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,

        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserProfile(),
            const SizedBox(height: 24),
            _buildStatsCards(),
            const SizedBox(height: 24),
            _buildLevelProgress(),
            const SizedBox(height: 32),
            _buildAchievements(),
            const SizedBox(height: 32),
            _buildLeaderboard(),
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue, width: 3),
            ),
            child: CircleAvatar(
              radius: 47,
              backgroundImage: AssetImage(AppImages.userAvatar),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _currentLevel['name'] ?? '異常紀錄者',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Lv. ${_currentLevel['level'] ?? 2}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard('總積分', '${_scoreService.currentScore}', Colors.blue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('目前等級', '${_currentLevel['level'] ?? 2}', Colors.green),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('全球排名', '#8,123', Colors.orange),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelProgress() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '下一等級進度',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _nextLevel != null 
                  ? '${_scoreService.currentScore} / ${_nextLevel!['minScore']}'
                  : '已達最高等級',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: _nextLevel != null 
              ? (_scoreService.currentScore - _currentLevel['minScore']) / 
                (_nextLevel!['minScore'] - _currentLevel['minScore'])
              : 1.0,
            backgroundColor: const Color(0xFF3A3A3A),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Text(
            _nextLevel != null 
              ? '再獲得 ${_nextLevel!['minScore'] - _scoreService.currentScore} 積分即可升級！'
              : '恭喜達到最高等級！',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '我的徽章',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildAchievementBadge('新手守護者', Icons.security, _unlockedAchievements.contains('新手守護者')),
            _buildAchievementBadge('異常紀錄者', Icons.warning, _unlockedAchievements.contains('異常紀錄者')),
            _buildAchievementBadge('警惕之眼', Icons.visibility, _unlockedAchievements.contains('警惕之眼')),
            _buildAchievementBadge('稽核助理', Icons.assignment, _unlockedAchievements.contains('稽核助理')),
            _buildAchievementBadge('資訊分析員', Icons.analytics, _unlockedAchievements.contains('資訊分析員')),
            _buildAchievementBadge('真相追索者', Icons.search, _unlockedAchievements.contains('真相追索者')),
          ],
        ),
      ],
    );
  }

  Widget _buildAchievementBadge(String title, IconData icon, bool unlocked) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: unlocked ? const Color(0xFF2A2A2A) : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: unlocked ? Colors.blue.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: unlocked ? Colors.blue : Colors.grey,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: unlocked ? Colors.white : Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '英雄榜',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildLeaderboardItem('#8,123', '正義使者A', '1,265', false),
        _buildLeaderboardItem('#8,124', '守護者9527', '1,255', false),
        _buildLeaderboardItem('#8,125', _currentLevel['name'] ?? '異常紀錄者', '${_scoreService.currentScore}', true),
        _buildLeaderboardItem('#8,126', '貓貓貓拳', '1,240', false),
        _buildLeaderboardItem('#8,127', '孤獨的美食家', '1,238', false),
      ],
    );
  }

  Widget _buildLeaderboardItem(String rank, String name, String score, bool isCurrentUser) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrentUser ? const Color(0xFF1E3A8A) : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: isCurrentUser ? Border.all(color: Colors.blue, width: 2) : null,
      ),
      child: Row(
        children: [
          Text(
            rank,
            style: TextStyle(
              color: isCurrentUser ? Colors.blue : Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          const CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFF3A3A3A),
            child: Icon(Icons.person, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: isCurrentUser ? Colors.white : Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            score,
            style: TextStyle(
              color: isCurrentUser ? Colors.blue : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              '查看完整排行',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              '開始新的檢舉',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}