// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses_by_city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpensesByCity _$ExpensesByCityFromJson(Map<String, dynamic> json) =>
    ExpensesByCity(
      city: json['city'] as String,
      expenses: (json['expenses'] as num).toDouble(),
    );

Map<String, dynamic> _$ExpensesByCityToJson(ExpensesByCity instance) =>
    <String, dynamic>{
      'city': instance.city,
      'expenses': instance.expenses,
    };
