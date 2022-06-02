import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'package:clients_api/clients_api.dart';

part 'expenses_by_city.g.dart';

/// {@template expenses_by_city}
/// Clients expenses grouped by city.
///
/// Contains a [city] and total clients [expenses].
///
/// [ExpensesByCity]s are immutable and can be copied using [copyWith], in addition to being serialized and deserialized
/// using [toJson] and [fromJson] respectively.
/// {@endtemplate}
@immutable
@JsonSerializable()
class ExpensesByCity extends Equatable {
  /// {@macro client}
  const ExpensesByCity({
    required this.city,
    required this.expenses,
  });

  /// The city by which clients expenses are grouped.
  final String city;

  /// The expenses of clients.
  final double expenses;

  /// Returns a copy of this expenses with the given values updated.
  ///
  /// {@macro expenses_by_city}
  copyWith({
    String? city,
    double? expenses,
  }) {
    return ExpensesByCity(
      city: city ?? this.city,
      expenses: expenses ?? this.expenses,
    );
  }

  /// Deserializes the given [JsonMap] into a [ExpensesByCity].
  static ExpensesByCity fromJson(JsonMap json) => _$ExpensesByCityFromJson(json);

  /// Converts this [ExpensesByCity] into a [JsonMap].
  JsonMap toJson() => _$ExpensesByCityToJson(this);

  @override
  List<Object?> get props => [city, expenses];
}
