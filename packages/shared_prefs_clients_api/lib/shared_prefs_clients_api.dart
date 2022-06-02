/// An implementation of the ClientsApi that uses NSUserDefaults on iOS and SharedPreferences on Android for local data
/// storage.
library shared_prefs_clients_api;

export 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

export 'src/shared_prefs_clients_api.dart';
