import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  static const String _baseUrl = 'http://192.168.2.16:6000';
  static const String _userId = 'flutter_user';

  String getWelcomeMessage() {
    return "嗨！我是瓜瓜，你的詐騙偵測助手！有什麼可疑訊息想要我幫你分析嗎？";
  }

  Future<Map<String, dynamic>> getResponse(String userMessage) async {
    // 模擬高風險回應
    return {
      'text': '⚠️ 瓜瓜偵測到這可能是詐騙訊息！對方可能正在嘗試騙取你的個人資訊或金錢。請立即停止對話並考慮檢舉此帳號。',
      'riskLevel': 'high',
    };
  }
}