import 'package:get/get.dart';
import '../models/room_model.dart';
import '../models/chat_message_model.dart';
import '../services/api_service.dart';

class ChatController extends GetxController {
  final Room room;
  final ApiService _apiService = ApiService();

  ChatController(this.room) {
    _loadChatHistory();
  }

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;

  void _loadChatHistory() async {
    try {
      final updatedRoom = await _apiService.getHistoryRoom(room.id);

      _logRoomDetails(updatedRoom);

      messages.value = _safeParseChatMessages(updatedRoom);
    } catch (e) {
      print('Error loading chat history: $e');
      Get.snackbar('Error', 'Failed to load chat history');
    }
  }

  List<ChatMessage> _safeParseChatMessages(Room room) {
    try {
      if (room.history == null || room.history!.isEmpty) {
        print('No chat history available');
        return [];
      }

      return room.history!.map((historyItem) {
        if (historyItem.length < 2) {
          print('Invalid history item: $historyItem');
          return null;
        }

        final type = historyItem[0] == 'human'
            ? MessageType.human
            : MessageType.assistant;
        final content = historyItem[1];

        if (type == MessageType.assistant && content is Map) {
          return ChatMessage(
              text: content['message'] ?? '',
              type: type,
              sources: _parseSources(content['sources'])
          );
        }

        return ChatMessage(
            text: content.toString(),
            type: type
        );
      }).whereType<ChatMessage>().toList();
    } catch (e) {
      print('Error parsing chat messages: $e');
      return [];
    }
  }

  List<ChatSource>? _parseSources(dynamic sourcesData) {
    if (sourcesData == null) return null;

    try {
      return (sourcesData as List).map((source) {
        return ChatSource(
            title: source['metadata']?['title'] ?? '',
            url: source['metadata']?['url'] ?? ''
        );
      }).toList();
    } catch (e) {
      print('Error parsing sources: $e');
      return null;
    }
  }

  void _logRoomDetails(Room room) {
    print('Room Details:');
    print('ID: ${room.id}');
    print('User Identify: ${room.userIdentify}');
    print('Created At: ${room.createdAt}');
    print('History Length: ${room.history?.length ?? 0}');

    if (room.history != null) {
      room.history!.asMap().forEach((index, item) {
        print('History Item $index: $item');
      });
    }
  }

  Future<void> sendMessage(String query) async {
    if (query.trim().isEmpty) return;

    messages.add(ChatMessage(
        text: query,
        type: MessageType.human
    ));
    isLoading.value = true;

    try {
      final response = await _apiService.sendChatMessage(room.id, query);

      final assistantMessage = ChatMessage(
          text: response['message'],
          type: MessageType.assistant,
          sources: _parseSources(response['sources'])
      );

      messages.add(assistantMessage);
    } catch (e) {
      messages.add(ChatMessage(
          text: '메시지 전송 중 오류가 발생했습니다.',
          type: MessageType.assistant
      ));
      Get.snackbar('Error', 'Failed to send message');
    } finally {
      isLoading.value = false;
    }
  }
}