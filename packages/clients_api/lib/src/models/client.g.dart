// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Client _$ClientFromJson(Map<String, dynamic> json) => Client(
      id: json['id'] as String?,
      name: json['name'] as String,
      city: json['city'] as String? ?? 'Batumi',
      expenses: (json['expenses'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$ClientToJson(Client instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'city': instance.city,
      'expenses': instance.expenses,
    };
