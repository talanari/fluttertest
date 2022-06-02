import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'package:clients_api/clients_api.dart';

part 'client.g.dart';

/// {@template client}
/// A client.
///
/// Contains a [name], [city], [expenses] and [id].
///
/// If an [id] is provided, it cannot be empty.
///
/// [Client]s are immutable and can be copied using [copyWith], in addition to being serialized and deserialized using
/// [toJson] and [fromJson] respectively.
/// {@endtemplate}
@immutable
@JsonSerializable()
class Client extends Equatable {
  /// {@macro client}
  Client({
    this.id,
    required this.name,
    this.city = 'Batumi',
    this.expenses = 0,
  }) : assert(
          id == null || id.isNotEmpty,
          'id should be either null or not empty',
        );

  /// The unique identifier of the client.
  final String? id;

  /// The name of the client.
  ///
  /// Note that name is required and cannot be empty.
  final String name;

  /// The city where the client lives.
  ///
  /// Defaults to "Batumi".
  final String city;

  /// The expenses of the client.
  ///
  /// Defaults to 0.
  final double expenses;

  /// Returns a copy of this client with the given values updated.
  ///
  /// {@macro client}
  Client copyWith({
    String? id,
    String? name,
    String? city,
    double? expenses,
  }) {
    return Client(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      expenses: expenses ?? this.expenses,
    );
  }

  /// Deserializes the given [JsonMap] into a [Client].
  static Client fromJson(JsonMap json) => _$ClientFromJson(json);

  /// Converts this [Client] into a [JsonMap].
  JsonMap toJson() => _$ClientToJson(this);

  @override
  List<Object?> get props => [id, name, city, expenses];
}
