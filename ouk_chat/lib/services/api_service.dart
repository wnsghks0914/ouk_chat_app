import 'package:dio/dio.dart';
import '../models/room_model.dart';
import '../models/chat_message_model.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));

  Future<Room> createRoom(String userIdentify) async {
    try {
      final response = await _dio.post('/room', data: {'userIdentify': userIdentify});
      print('Create Room Response: ${response.data}');
      return Room.fromJson(response.data);
    } catch (e) {
      print('Error in createRoom: $e');
      rethrow;
    }
  }

  Future<List<Room>> getRoomsByUser(String userIdentify) async {
    final response = await _dio.get('/room/user/$userIdentify');
    return (response.data as List)
        .map((roomJson) => Room.fromJson(roomJson))
        .toList();
  }

  Future<Map<String, dynamic>> sendChatMessage(int roomId, String query) async {
    try {
      final response = await _dio.post('/room/$roomId/chat', data: {'query': query});

      return {
        'message': response.data['message'] ?? '',
        'sources': response.data['sources'] ?? []
      };
    } catch (e) {
      rethrow;
    }
  }

  Future<Room> getHistoryRoom(int roomId) async {
    try {
      final response = await _dio.get('/room/$roomId');

      // 전체 JSON 구조 출력
      print('Full Room JSON: ${response.data}');

      return Room.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}