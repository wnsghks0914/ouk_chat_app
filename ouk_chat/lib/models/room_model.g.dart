// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map<String, dynamic> json) => Room(
      id: (json['id'] as num).toInt(),
      userIdentify: json['userIdentify'] as String,
      createdAt: Room._dateTimeFromJson(json['createdAt']),
      history: Room._historyFromJson(json['history']),
    );

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'id': instance.id,
      'userIdentify': instance.userIdentify,
      'createdAt': Room._dateTimeToJson(instance.createdAt),
      'history': Room._historyToJson(instance.history),
    };
