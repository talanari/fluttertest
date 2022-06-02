import 'package:test/test.dart';

import 'package:clients_api/clients_api.dart';

class TestClientsApi extends ClientsApi {
  TestClientsApi() : super();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('ClientsApi', () {
    test('can be constructed', () {
      expect(TestClientsApi.new, returnsNormally);
    });
  });
}
