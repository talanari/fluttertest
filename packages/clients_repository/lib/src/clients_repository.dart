import 'dart:async';

import 'package:clients_api/clients_api.dart';

/// {@template clients_repository}
/// A repository that handles clients related requests.
/// {@endtemplate}
class ClientsRepository {
  /// {@macro clients_repository}
  const ClientsRepository({
    required ClientsApi clientsApi,
  }) : _clientsApi = clientsApi;

  final ClientsApi _clientsApi;

  /// Provides a [Stream] of all clients.
  Stream<List<Client>> getClients() => _clientsApi.getClients();

  /// Creates a new [client].
  ///
  /// If a [client] with the same name already exists, a [ClientNameDuplicateException] error is thrown.
  Future<Response> createClient(Client client) => _clientsApi.createClient(client);

  /// Saves a [client].
  ///
  /// If a [client] with the same id already exists, it will be replaced. If a [client] with the same name already
  /// exists, a [ClientNameDuplicateException] error is thrown.
  Future<Response> saveClient(Client client) => _clientsApi.saveClient(client);

  /// Deletes the client with the given id.
  ///
  /// If no client with the given id exists, a [ClientNotFoundException] error is thrown.
  Future<Response> deleteClient(String id) => _clientsApi.deleteClient(id);

  /// Provides a [Stream] of all clients expenses grouped by city.
  Stream<List<ExpensesByCity>> getClientsExpensesByCity() => _clientsApi.getClientsExpensesByCity();
}
