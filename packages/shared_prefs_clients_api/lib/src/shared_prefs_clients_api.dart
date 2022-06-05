import 'dart:async';
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:clients_api/clients_api.dart';

/// {@template shared_prefs_clients_api}
/// An implementation of the [ClientsApi] that uses NSUserDefaults on iOS and SharedPreferences on Android for local
/// data storage.
/// {@endtemplate}
class SharedPrefsClientsApi implements ClientsApi {
  /// {@macro shared_prefs_clients_api}
  SharedPrefsClientsApi({
    required SharedPreferences sharedPrefs,
  }) : _sharedPrefs = sharedPrefs {
    _init();
  }

  final SharedPreferences _sharedPrefs;

  final _clientStreamController = BehaviorSubject<List<Client>>.seeded(const []);
  final _clientsExpensesStreamController = BehaviorSubject<List<ExpensesByCity>>.seeded(const []);

  /// The key used for storing clients data locally.
  ///
  /// This is only exposed for testing and shouldn't be used by consumers of this library.
  @visibleForTesting
  static const kClientsCollectionKey = '__clients_collection_key__';

  String? _getValue(String key) => _sharedPrefs.getString(key);
  Future<void> _setValue(String key, String value) => _sharedPrefs.setString(key, value);

  void _init() {
    final clientsJson = _getValue(kClientsCollectionKey);

    if (clientsJson != null) {
      final clientsDecoded = List<Map>.from(json.decode(clientsJson) as List);
      final clients = clientsDecoded.map((jsonMap) => Client.fromJson(Map<String, dynamic>.from(jsonMap))).toList();
      final expensesByCity = clientsDecoded
          .fold(
            <Map<String, dynamic>>[],
            (List<Map<String, dynamic>> acc, client) {
              final cityIndex = acc.indexWhere((el) => el['city'] == client['city']);
              final List<Map<String, dynamic>> newAcc = [...acc];

              if (cityIndex == -1) {
                newAcc.add({
                  'city': client['city'],
                  'expenses': client['expenses'],
                });
              } else {
                // TODO: should be refactored, quickfix to double floating point precision problem using Decimal package
                newAcc[cityIndex]['expenses'] = (Decimal.parse(newAcc[cityIndex]['expenses'].toString()) +
                        Decimal.parse(client['expenses'].toString()))
                    .toDouble();
              }

              return newAcc;
            },
          )
          .map((jsonMap) => ExpensesByCity.fromJson(Map<String, dynamic>.from(jsonMap)))
          .toList();

      _clientStreamController.add(clients);
      _clientsExpensesStreamController.add(expensesByCity);
    } else {
      _clientStreamController.add(const []);
      _clientsExpensesStreamController.add(const []);
    }
  }

  @override
  Stream<List<Client>> getClients() => _clientStreamController.asBroadcastStream();

  @override
  Future<Response> createClient(Client client) {
    final clients = [..._clientStreamController.value];
    final clientNameIndex = clients.indexWhere((t) => t.name == client.name);

    if (clientNameIndex >= 0) {
      throw ClientNameDuplicateException();
    }

    // Simulating API answer providing Id for new client record
    final clientWithId = client.copyWith(id: const Uuid().v4());
    clients.add(clientWithId);
    _clientStreamController.add(clients);

    final expensesByCity = [..._clientsExpensesStreamController.value];
    final cityIndex = expensesByCity.indexWhere((t) => t.city == client.city);

    if (cityIndex >= 0) {
      // TODO: should be refactored, quickfix to double floating point precision problem using Decimal package
      expensesByCity[cityIndex] = expensesByCity[cityIndex].copyWith(
          expenses:
              (Decimal.parse(expensesByCity[cityIndex].expenses.toString()) + Decimal.parse(client.expenses.toString()))
                  .toDouble());
    } else {
      expensesByCity.add(ExpensesByCity(city: client.city, expenses: client.expenses));
    }

    _clientsExpensesStreamController.add(expensesByCity);

    _setValue(kClientsCollectionKey, json.encode(clients));

    return Future.value(
      Response(
        id: clientWithId.id!,
        status: true,
      ),
    );
  }

  @override
  Future<Response> saveClient(Client client) {
    final clients = [..._clientStreamController.value];
    final clientNameIndex = clients.indexWhere((t) => t.name == client.name);
    final clientIndex = clients.indexWhere((t) => t.id == client.id);

    if (clientNameIndex >= 0 && clientNameIndex != clientIndex) {
      throw ClientNameDuplicateException();
    }

    final oldClient = clients[clientIndex];
    final hasNewCityAppeared = clients.indexWhere((t) => t.city == client.city) == -1;
    clients[clientIndex] = client;
    final hasCityLostAllClients = clients.indexWhere((t) => t.city == oldClient.city) == -1;
    _clientStreamController.add(clients);

    final expensesByCity = [..._clientsExpensesStreamController.value];
    final oldCityIndex = expensesByCity.indexWhere((t) => t.city == oldClient.city);

    if (hasCityLostAllClients) {
      expensesByCity.removeAt(oldCityIndex);
    } else {
      // TODO: should be refactored, quickfix to double floating point precision problem using Decimal package
      expensesByCity[oldCityIndex] = expensesByCity[oldCityIndex].copyWith(
          expenses: (Decimal.parse(expensesByCity[oldCityIndex].expenses.toString()) -
                  Decimal.parse(oldClient.expenses.toString()))
              .toDouble());
    }

    final newCityIndex = expensesByCity.indexWhere((t) => t.city == client.city);

    if (hasNewCityAppeared) {
      expensesByCity.add(ExpensesByCity(city: client.city, expenses: client.expenses));
    } else {
      // TODO: should be refactored, quickfix to double floating point precision problem using Decimal package
      expensesByCity[newCityIndex] = expensesByCity[newCityIndex].copyWith(
          expenses: (Decimal.parse(expensesByCity[newCityIndex].expenses.toString()) +
                  Decimal.parse(client.expenses.toString()))
              .toDouble());
    }

    _clientsExpensesStreamController.add(expensesByCity);

    _setValue(kClientsCollectionKey, json.encode(clients));

    return Future.value(
      Response(
        id: client.id!,
        status: true,
      ),
    );
  }

  @override
  Future<Response> deleteClient(String id) async {
    final clients = [..._clientStreamController.value];
    final clientIndex = clients.indexWhere((t) => t.id == id);

    if (clientIndex == -1) {
      throw ClientNotFoundException();
    } else {
      final oldClient = clients[clientIndex];
      clients.removeAt(clientIndex);
      final hasCityLostAllClients = clients.indexWhere((t) => t.city == oldClient.city) == -1;
      _clientStreamController.add(clients);

      final expensesByCity = [..._clientsExpensesStreamController.value];
      final oldCityIndex = expensesByCity.indexWhere((t) => t.city == oldClient.city);

      if (hasCityLostAllClients) {
        expensesByCity.removeAt(oldCityIndex);
      } else {
        // TODO: should be refactored, quickfix to double floating point precision problem using Decimal package
        expensesByCity[oldCityIndex] = expensesByCity[oldCityIndex].copyWith(
            expenses: (Decimal.parse(expensesByCity[oldCityIndex].expenses.toString()) -
                    Decimal.parse(oldClient.expenses.toString()))
                .toDouble());
      }

      _clientsExpensesStreamController.add(expensesByCity);

      _setValue(kClientsCollectionKey, json.encode(clients));

      return Future.value(
        Response(
          id: id,
          status: true,
        ),
      );
    }
  }

  // Let's imagine that API provides what we need (as it should be). Also there is a condition to be able to switch
  // implementation with minimal efforts.
  @override
  Stream<List<ExpensesByCity>> getClientsExpensesByCity() => _clientsExpensesStreamController.asBroadcastStream();
}
