import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clients_repository/clients_repository.dart';
import 'package:fluttertest/features/clients/clients.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClientsBloc(
        clientsRepository: context.read<ClientsRepository>(),
      )..add(const ClientsSubscriptionRequested()),
      child: const ClientsView(),
    );
  }
}

class ClientsView extends StatelessWidget {
  const ClientsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Клиенты'),
      ),
      body: BlocConsumer<ClientsBloc, ClientsState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == ClientsStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Ошибка загрузки списка клиентов'),
                ),
              );
          }

          if (state.status == ClientsStatus.clientDeletionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Ошибка удаления клиента'),
                ),
              );
          }
        },
        builder: (context, state) {
          switch (state.status) {
            case ClientsStatus.initial:
              return const SizedBox();
            case ClientsStatus.loading:
              return const Center(child: CupertinoActivityIndicator());
            case ClientsStatus.emptyList:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Список клиентов пуст',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => context.read<ClientsBloc>().add(const ClientsFirstClientAdded()),
                      child: const Text('Создать'),
                    ),
                  ],
                ),
              );
            case ClientsStatus.success:
              return const ClientsDataTable();
            case ClientsStatus.clientDeletionFailure:
            case ClientsStatus.failure:
              return Center(
                child: ElevatedButton(
                  onPressed: () => context.read<ClientsBloc>().add(const ClientsReloadRequested()),
                  child: const Text('Обновить список клиентов'),
                ),
              );
          }
        },
      ),
    );
  }
}
