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

  Future<String> getResponse(String userMessage) async {
    try {
      print('發送請求到: $_baseUrl/chat');
      print('請求內容: {"message": "$userMessage", "user_id": "$_userId"}');
      
      final response = await http.post(
        Uri.parse('$_baseUrl/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'message': userMessage,
          'user_id': _userId,
        }),
      );

      print('回應狀態碼: ${response.statusCode}');
      print('回應內容: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response']['text'] ?? '瓜瓜沒有收到回應';
      } else {
        return '瓜瓜連線有問題，請稍後再試 (狀態碼: ${response.statusCode})';
      }
    } catch (e) {
      print('錯誤詳情: $e');
      return '瓜瓜連線失敗: $e';
    }
  }
}