import 'package:flutter/material.dart';
import '../models/report.dart';

class ReportItem extends StatelessWidget {
  final Report report;
  final VoidCallback? onTap;

  const ReportItem({
    super.key,
    required this.report,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            _buildStatusIcon(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '提交日期：${_formatDate(report.submitDate)}',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'AI 判斷：${report.aiJudgment}',
                    style: TextStyle(
                      color: _getJudgmentColor(),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '處理進度：${_getStatusText()}',
                        style: TextStyle(
                          color: _getStatusColor(),
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${(report.progress * 100).toInt()}%',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: report.progress,
                    backgroundColor: Colors.grey.shade700,
                    valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor()),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    IconData iconData;
    Color backgroundColor;
    Color iconColor;

    switch (report.status) {
      case ReportStatus.completed:
        iconData = Icons.check;
        backgroundColor = Colors.green.shade700;
        iconColor = Colors.white;
        break;
      case ReportStatus.processing:
        iconData = Icons.hourglass_empty;
        backgroundColor = Colors.orange.shade700;
        iconColor = Colors.white;
        break;
      case ReportStatus.needsAttention:
        iconData = Icons.warning;
        backgroundColor = Colors.red.shade700;
        iconColor = Colors.white;
        break;
      default:
        iconData = Icons.info;
        backgroundColor = Colors.blue.shade700;
        iconColor = Colors.white;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  Color _getJudgmentColor() {
    switch (report.riskLevel) {
      case RiskLevel.high:
        return Colors.red.shade400;
      case RiskLevel.medium:
        return Colors.orange.shade400;
      case RiskLevel.low:
        return Colors.grey.shade400;
    }
  }

  String _getStatusText() {
    switch (report.status) {
      case ReportStatus.completed:
        return '已結案';
      case ReportStatus.processing:
        return '警方處理中';
      case ReportStatus.needsAttention:
        return '需補件';
      default:
        return '未知狀態';
    }
  }

  Color _getStatusColor() {
    switch (report.status) {
      case ReportStatus.completed:
        return Colors.green.shade400;
      case ReportStatus.processing:
        return Colors.orange.shade400;
      case ReportStatus.needsAttention:
        return Colors.red.shade400;
      default:
        return Colors.grey.shade400;
    }
  }

  Color _getProgressColor() {
    switch (report.status) {
      case ReportStatus.completed:
        return Colors.green;
      case ReportStatus.processing:
        return Colors.orange;
      case ReportStatus.needsAttention:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}