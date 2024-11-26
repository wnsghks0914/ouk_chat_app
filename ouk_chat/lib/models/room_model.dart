import 'package:json_annotation/json_annotation.dart';
import 'chat_message_model.dart';

part 'room_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Room {
  final int id;
  final String userIdentify;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? createdAt;

  // 초기값을 null로 설정
  @JsonKey(
      fromJson: _historyFromJson,
      toJson: _historyToJson,
      defaultValue: null
  )
  final List<List<dynamic>>? history;

  Room({
    required this.id,
    required this.userIdentify,
    this.createdAt,
    this.history
  });

  List<ChatMessage> getChatMessages() {
    print('Raw history: $history');

    if (history == null || history!.isEmpty) {
      print('History is null or empty');
      return [];
    }

    print('History length: ${history!.length}');

    return history!.map((historyItem) {
      print('Processing history item: $historyItem');
      print('History item type: ${historyItem.runtimeType}');
      print('History item length: ${historyItem.length}');

      // 안전한 타입 및 길이 확인
      if (historyItem is! List || historyItem.length < 2) {
        print('Invalid history item structure');
        return null;
      }

      final type = historyItem[0] == 'human'
          ? MessageType.human
          : MessageType.assistant;
      final content = historyItem[1];

      print('Type: $type, Content: $content');
      print('Content type: ${content.runtimeType}');

      if (type == MessageType.assistant && content is Map) {
        return ChatMessage(
            text: content['message'] ?? '',
            type: type,
            sources: content['sources'] != null
                ? (content['sources'] as List).map((source) {
              print('Source: $source');
              return ChatSource(
                  title: source['metadata']?['title'] ?? '',
                  url: source['metadata']?['url'] ?? ''
              );
            }).toList()
                : null
        );
      }

      return ChatMessage(
          text: content.toString(),
          type: type
      );
    }).whereType<ChatMessage>().toList();
  }

  factory Room.fromJson(dynamic json) {
    print('Room.fromJson called with: $json');

    if (json is String) {
      return Room(
          id: 0,
          userIdentify: json,
          createdAt: DateTime.now()
      );
    }

    if (json is Map<String, dynamic>) {
      print('Parsing Room from Map');
      try {
        // json_serializable을 통해 Room 객체 생성
        return _$RoomFromJson(json);
      } catch (e) {
        print('Error in Room.fromJson: $e');
        // 파싱 실패 시 기본값으로 Room 생성
        return Room(
            id: json['id'] ?? 0,
            userIdentify: json['userIdentify'] ?? '',
            createdAt: _dateTimeFromJson(json['createdAt']),
            history: _historyFromJson(json['history'])
        );
      }
    }

    throw ArgumentError('Invalid json type for Room');
  }

  static DateTime? _dateTimeFromJson(dynamic json) {
    if (json == null) return null;
    return json is String ? DateTime.parse(json) : null;
  }

  static String? _dateTimeToJson(DateTime? dateTime) {
    return dateTime?.toIso8601String();
  }

  static List<List<dynamic>>? _historyFromJson(dynamic json) {
    print('_historyFromJson called with: $json');

    if (json == null) return null;

    // json이 List 형태인지 확인
    if (json is List) {
      // 각 아이템이 List인지 확인하고 형변환
      return json.map((item) {
        // 이미 List인 경우 그대로 반환
        if (item is List) return item;

        // Map인 경우 List로 변환 시도
        if (item is Map) {
          return [item['type'] ?? '', item['content'] ?? ''];
        }

        // 기타 경우 빈 리스트
        return [];
      }).toList();
    }

    // 다른 형식의 경우 null 반환
    return null;
  }

  static dynamic _historyToJson(List<List<dynamic>>? history) {
    return history?.map((item) => item.map((e) => e).toList()).toList();
  }
}