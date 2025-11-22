import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        backgroundColor: const Color(0xFF1A1A1A),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text(
          '設定頁面',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}