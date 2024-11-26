import 'package:json_annotation/json_annotation.dart';

part 'chat_message_model.g.dart';

enum MessageType { human, assistant }

@JsonSerializable()
class ChatMessage {
  final String text;
  @JsonKey(unknownEnumValue: MessageType.assistant)
  final MessageType type;
  final List<ChatSource>? sources;

  ChatMessage({
    required this.text,
    required this.type,
    this.sources
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}

@JsonSerializable()
class ChatSource {
  final String title;
  final String url;

  ChatSource({
    required this.title,
    required this.url
  });

  factory ChatSource.fromJson(Map<String, dynamic> json) {
    final metadata = json['metadata'] ?? {};
    return ChatSource(
        title: metadata['title'] ?? '',
        url: metadata['url'] ?? ''
    );
  }
}