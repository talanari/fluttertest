import 'package:clients_api/clients_api.dart';

/// {@template clients_api}
/// The interface and models for an API providing access to clients.
/// {@endtemplate}
abstract class ClientsApi {
  /// {@macro clients_api}
  const ClientsApi();

  /// Provides a [Stream] of all clients.
  Stream<List<Client>> getClients();

  /// Creates a new [client].
  Future<Response> createClient(Client client);

  /// Saves a [client].
  ///
  /// If a [client] with the same id already exists, it will be replaced.
  Future<Response> saveClient(Client client);

  /// Deletes the client with the given id.
  ///
  /// If no client with the given id exists, a [ClientNotFoundException] error is thrown.
  Future<Response> deleteClient(String id);

  /// Provides a [Stream] of all clients expenses grouped by city.
  Stream<List<ExpensesByCity>> getClientsExpensesByCity();
}

/// Error thrown when a [Client] with a given id is not found.
class ClientNotFoundException implements Exception {}

/// Error thrown when a [Client] with a given name already exists.
class ClientNameDuplicateException implements Exception {}
