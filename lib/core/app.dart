import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clients_repository/clients_repository.dart';
import 'package:fluttertest/core/theme.dart';
import 'package:fluttertest/features/home/home.dart';

class FlutterTestApp extends StatelessWidget {
  const FlutterTestApp({Key? key, required this.clientsRepository}) : super(key: key);

  final ClientsRepository clientsRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: clientsRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FlutterTestTheme.light,
      darkTheme: FlutterTestTheme.dark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
