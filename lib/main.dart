import 'package:flutter/widgets.dart';

import 'package:fluttertest/core/bootstrap.dart';
import 'package:shared_prefs_clients_api/shared_prefs_clients_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final clientsApi = SharedPrefsClientsApi(
    sharedPrefs: await SharedPreferences.getInstance(),
  );

  bootstrap(clientsApi: clientsApi);
}
