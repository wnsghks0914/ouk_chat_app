// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      text: json['text'] as String,
      type: $enumDecode(_$MessageTypeEnumMap, json['type'],
          unknownValue: MessageType.assistant),
      sources: (json['sources'] as List<dynamic>?)
          ?.map((e) => ChatSource.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'text': instance.text,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'sources': instance.sources,
    };

const _$MessageTypeEnumMap = {
  MessageType.human: 'human',
  MessageType.assistant: 'assistant',
};

ChatSource _$ChatSourceFromJson(Map<String, dynamic> json) => ChatSource(
      title: json['title'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$ChatSourceToJson(ChatSource instance) =>
    <String, dynamic>{
      'title': instance.title,
      'url': instance.url,
    };
