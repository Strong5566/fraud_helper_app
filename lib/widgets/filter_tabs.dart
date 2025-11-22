import 'package:flutter/material.dart';
import '../models/report.dart';

class FilterTabs extends StatelessWidget {
  final ReportStatus selectedStatus;
  final Function(ReportStatus) onStatusChanged;

  const FilterTabs({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildTab('全部', ReportStatus.all),
          const SizedBox(width: 8),
          _buildTab('處理中', ReportStatus.processing),
          const SizedBox(width: 8),
          _buildTab('已完成', ReportStatus.completed),
          const SizedBox(width: 8),
          _buildTab('需補件', ReportStatus.needsAttention),
        ],
      ),
    );
  }

  Widget _buildTab(String text, ReportStatus status) {
    final isSelected = selectedStatus == status;
    return GestureDetector(
      onTap: () => onStatusChanged(status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade600,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade300,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}