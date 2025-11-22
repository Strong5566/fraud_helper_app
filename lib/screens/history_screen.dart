import 'package:flutter/material.dart';
import '../models/report.dart';
import '../widgets/filter_tabs.dart';
import '../widgets/report_item.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  ReportStatus _selectedStatus = ReportStatus.all;
  List<Report> _reports = Report.getMockData();

  List<Report> get _filteredReports {
    if (_selectedStatus == ReportStatus.all) {
      return _reports;
    }
    return _reports.where((report) => report.status == _selectedStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text(
          '檢舉歷史',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,

        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          FilterTabs(
            selectedStatus: _selectedStatus,
            onStatusChanged: (status) {
              setState(() {
                _selectedStatus = status;
              });
            },
          ),
          Expanded(
            child: _filteredReports.isEmpty
                ? const Center(
                    child: Text(
                      '沒有符合條件的檢舉記錄',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredReports.length,
                    itemBuilder: (context, index) {
                      return ReportItem(
                        report: _filteredReports[index],
                        onTap: () {
                          // TODO: 導航到詳細頁面
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}