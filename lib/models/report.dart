enum ReportStatus { all, processing, completed, needsAttention }

enum RiskLevel { low, medium, high }

class Report {
  final String id;
  final String title;
  final DateTime submitDate;
  final String aiJudgment;
  final ReportStatus status;
  final RiskLevel riskLevel;
  final double progress;

  Report({
    required this.id,
    required this.title,
    required this.submitDate,
    required this.aiJudgment,
    required this.status,
    required this.riskLevel,
    required this.progress,
  });

  static List<Report> getMockData() {
    return [
      Report(
        id: 'IG_Scammer_01',
        title: 'IG_Scammer_01',
        submitDate: DateTime(2023, 10, 26),
        aiJudgment: '高風險詐騙帳號',
        status: ReportStatus.completed,
        riskLevel: RiskLevel.high,
        progress: 1.0,
      ),
      Report(
        id: 'FB_Fraudster_A',
        title: 'FB_Fraudster_A',
        submitDate: DateTime(2023, 10, 25),
        aiJudgment: '中風險詐騙帳號',
        status: ReportStatus.processing,
        riskLevel: RiskLevel.medium,
        progress: 0.75,
      ),
      Report(
        id: 'Scam_Account_XYZ',
        title: 'Scam_Account_XYZ',
        submitDate: DateTime(2023, 10, 24),
        aiJudgment: '資訊不足',
        status: ReportStatus.needsAttention,
        riskLevel: RiskLevel.low,
        progress: 0.25,
      ),
    ];
  }
}