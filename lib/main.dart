import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const FraudDetectorApp());
}

class FraudDetectorApp extends StatelessWidget {
  const FraudDetectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '詐騙偵測器',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      ),
      home: const MainScreen(),
    );
  }
}
