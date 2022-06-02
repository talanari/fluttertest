import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clients_api/clients_api.dart';
import 'package:shared_prefs_clients_api/shared_prefs_clients_api.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('SharedPrefsClientsApi', () {
    late SharedPreferences sharedPrefs;

    final clients = [
      Client(
        id: '0',
        name: 'Pyotr',
        city: 'Batumi',
        expenses: 0,
      ),
      Client(
        id: '1',
        name: 'Alex',
        city: 'Saint Petersburg',
        expenses: 1,
      ),
      Client(
        id: '2',
        name: 'John',
        city: 'New York',
        expenses: 2,
      ),
      Client(
        id: '3',
        name: 'Susan',
        city: 'Washington',
        expenses: 3,
      ),
      Client(
        id: '4',
        name: 'Maria',
        city: 'Tyumen',
        expenses: 4.44,
      ),
    ];

    setUp(() {
      sharedPrefs = MockSharedPreferences();

      when(() => sharedPrefs.getString(any())).thenReturn(json.encode(clients));
      when(() => sharedPrefs.setString(any(), any())).thenAnswer((_) async => true);
    });

    SharedPrefsClientsApi createSubject() {
      return SharedPrefsClientsApi(
        sharedPrefs: sharedPrefs,
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(
          createSubject,
          returnsNormally,
        );
      });

      group('initializes clients stream', () {
        test('with existing clients if present', () {
          final subject = createSubject();

          expect(subject.getClients(), emits(clients));

          verify(
            () => sharedPrefs.getString(
              SharedPrefsClientsApi.kClientsCollectionKey,
            ),
          ).called(1);
        });

        test('with empty list if no clients present', () {
          when(() => sharedPrefs.getString(any())).thenReturn(null);

          final subject = createSubject();

          expect(subject.getClients(), emits(const <Client>[]));

          verify(
            () => sharedPrefs.getString(
              SharedPrefsClientsApi.kClientsCollectionKey,
            ),
          ).called(1);
        });
      });
    });

    test('getClients returns stream of current clients', () {
      expect(
        createSubject().getClients(),
        emits(clients),
      );
    });

    group('saveClient', () {
      test('saves new client', () {
        final newClient = Client(
          id: '4',
          name: 'Michael',
          city: 'Los Angeles',
          expenses: 5.5,
        );
        final newClients = [...clients]..[4] = newClient;
        final subject = createSubject();

        expect(subject.saveClient(newClient), completes);
        expect(subject.getClients(), emits(newClients));

        verify(
          () => sharedPrefs.setString(
            SharedPrefsClientsApi.kClientsCollectionKey,
            json.encode(newClients),
          ),
        ).called(1);
      });

      test('saves new client with default values', () {
        final newClient = Client(
          id: '4',
          name: 'Helen',
        );
        final newClientWithDefaultValues = Client(
          id: '4',
          name: 'Helen',
          city: 'Batumi',
          expenses: 0,
        );
        final newClients = [...clients]..[4] = newClientWithDefaultValues;
        final subject = createSubject();

        expect(subject.saveClient(newClient), completes);
        expect(subject.getClients(), emits(newClients));

        verify(
          () => sharedPrefs.setString(
            SharedPrefsClientsApi.kClientsCollectionKey,
            json.encode(newClients),
          ),
        ).called(1);
      });

      test('updates existing client', () {
        final updatedClient = Client(
          id: '0',
          name: 'Pyotr',
          city: 'Ryazan',
          expenses: 100,
        );
        final newClients = [updatedClient, ...clients.sublist(1)];
        final subject = createSubject();

        expect(subject.saveClient(updatedClient), completes);
        expect(subject.getClients(), emits(newClients));

        verify(
          () => sharedPrefs.setString(
            SharedPrefsClientsApi.kClientsCollectionKey,
            json.encode(newClients),
          ),
        ).called(1);
      });

      test(
        'throws ClientNameDuplicateException when trying to save new client with already existing name',
        () {
          final newClient = Client(
            id: '7',
            name: 'Pyotr',
            city: 'Kaliningrad',
            expenses: 3500,
          );
          final subject = createSubject();

          expect(
            () => subject.saveClient(newClient),
            throwsA(isA<ClientNameDuplicateException>()),
          );
        },
      );

      test(
        'doesn\'t throw ClientNameDuplicateException when trying to update existing client with the same name',
        () {
          final updatedClient = Client(
            id: '0',
            name: 'Pyotr',
            city: 'Rostov',
            expenses: 1000,
          );
          final newClients = [updatedClient, ...clients.sublist(1)];
          final subject = createSubject();

          expect(subject.saveClient(updatedClient), completes);
          expect(subject.getClients(), emits(newClients));

          verify(
            () => sharedPrefs.setString(
              SharedPrefsClientsApi.kClientsCollectionKey,
              json.encode(newClients),
            ),
          ).called(1);
        },
      );
    });

    group('deleteClient', () {
      test('deletes existing client', () {
        final newClients = clients.sublist(1);
        final subject = createSubject();

        expect(subject.deleteClient(clients[0].id!), completes);
        expect(subject.getClients(), emits(newClients));

        verify(
          () => sharedPrefs.setString(
            SharedPrefsClientsApi.kClientsCollectionKey,
            json.encode(newClients),
          ),
        ).called(1);
      });

      test(
        'throws ClientNotFoundException if client with provided id is not found',
        () {
          final subject = createSubject();

          expect(
            () => subject.deleteClient('invalid_id'),
            throwsA(isA<ClientNotFoundException>()),
          );
        },
      );
    });
  });
}
