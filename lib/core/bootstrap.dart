import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:clients_api/clients_api.dart';
import 'package:clients_repository/clients_repository.dart';
import 'package:fluttertest/constants/constants.dart';
import 'package:fluttertest/core/app.dart';
import 'package:fluttertest/core/app_bloc_observer.dart';

void bootstrap({required ClientsApi clientsApi}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  final clientsRepository = ClientsRepository(clientsApi: clientsApi);

  runZonedGuarded(
    () async {
      // Adding licenses manually to register font license
      Paths.licenses.forEach((package, path) async {
        LicenseRegistry.addLicense(() async* {
          final licenseText = await rootBundle.loadString(path);
          yield LicenseEntryWithLineBreaks([package], licenseText);
        });
      });

      await BlocOverrides.runZoned(
        () async => runApp(
          FlutterTestApp(clientsRepository: clientsRepository),
        ),
        blocObserver: AppBlocObserver(),
      );
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
