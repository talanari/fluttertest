import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:clients_api/clients_api.dart';
import 'package:clients_repository/clients_repository.dart';

class MockClientsApi extends Mock implements ClientsApi {}

class FakeClient extends Fake implements Client {}

void main() {
  group('ClientsRepository', () {
    late ClientsApi api;

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

    setUpAll(() {
      registerFallbackValue(FakeClient());
    });

    setUp(() {
      api = MockClientsApi();
      when(() => api.getClients()).thenAnswer((_) => Stream.value(clients));
      when(() => api.createClient(any<Client>())).thenAnswer((_) async => const Response(id: '77', status: true));
      when(() => api.saveClient(any<Client>())).thenAnswer((_) async => const Response(id: '5', status: true));
      when(() => api.deleteClient(any<String>())).thenAnswer((_) async => const Response(id: '0', status: true));
    });

    ClientsRepository createSubject() => ClientsRepository(clientsApi: api);

    group('constructor', () {
      test('works properly', () {
        expect(
          createSubject,
          returnsNormally,
        );
      });
    });

    group('getClients', () {
      test('makes correct api request', () {
        final subject = createSubject();

        expect(
          subject.getClients(),
          isNot(throwsA(anything)),
        );

        verify(() => api.getClients()).called(1);
      });

      test('returns stream of current clients', () {
        expect(
          createSubject().getClients(),
          emits(clients),
        );
      });
    });

    group('createClient', () {
      test('makes correct api request', () {
        final newClient = Client(
          id: null,
          name: 'Mila',
          city: 'Kazan',
          expenses: 0.5,
        );

        final subject = createSubject();

        expect(subject.createClient(newClient), completes);

        verify(() => api.createClient(newClient)).called(1);
      });
    });

    group('saveClient', () {
      test('makes correct api request', () {
        final newClient = Client(
          id: '5',
          name: 'Michael',
          city: 'Los Angeles',
          expenses: 5.5,
        );

        final subject = createSubject();

        expect(subject.saveClient(newClient), completes);

        verify(() => api.saveClient(newClient)).called(1);
      });
    });

    group('deleteTodo', () {
      test('makes correct api request', () {
        final subject = createSubject();

        expect(subject.deleteClient(clients[0].id!), completes);

        verify(() => api.deleteClient(clients[0].id!)).called(1);
      });
    });
  });
}
