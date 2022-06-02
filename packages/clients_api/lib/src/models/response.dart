import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'package:clients_api/clients_api.dart';

part 'response.g.dart';

/// {@template response}
/// A client api response.
///
/// Contains a [status] and [id].
///
/// [Response]s are immutable and can deserialized using [fromJson].
/// {@endtemplate}
@immutable
@JsonSerializable()
class Response extends Equatable {
  /// {@macro response}
  const Response({
    required this.id,
    required this.status,
  });

  /// The unique identifier of the client.
  final String id;

  /// Status API responded to a request with.
  final bool status;

  /// Deserializes the given [JsonMap] into a [Response].
  static Response fromJson(JsonMap json) => _$ResponseFromJson(json);

  /// Converts this [Response] into a [JsonMap].
  JsonMap toJson() => _$ResponseToJson(this);

  @override
  List<Object> get props => [id, status];
}
