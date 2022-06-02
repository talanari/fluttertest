import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clients_api/clients_api.dart';
import 'package:clients_repository/clients_repository.dart';

part 'clients_event.dart';
part 'clients_state.dart';

class ClientsBloc extends Bloc<ClientsEvent, ClientsState> {
  ClientsBloc({
    required ClientsRepository clientsRepository,
  })  : _clientsRepository = clientsRepository,
        super(const ClientsState()) {
    on<ClientsSubscriptionRequested>(_onSubscriptionRequested);
    on<ClientsFirstClientAdded>(_onFirstClientAdded);
    on<ClientsClientDeleted>(_onClientDeleted);
    on<ClientsReloadRequested>(_onReloadRequested);
  }

  final ClientsRepository _clientsRepository;

  Future<void> _onSubscriptionRequested(
    ClientsSubscriptionRequested event,
    Emitter<ClientsState> emit,
  ) async =>
      await _onLoadRequested(emit);

  void _onFirstClientAdded(
    ClientsFirstClientAdded event,
    Emitter<ClientsState> emit,
  ) =>
      emit(state.copyWith(status: () => ClientsStatus.success));

  Future<void> _onClientDeleted(
    ClientsClientDeleted event,
    Emitter<ClientsState> emit,
  ) async {
    try {
      await _clientsRepository.deleteClient(event.client.id!);
    } on ClientNotFoundException {
      emit(state.copyWith(status: () => ClientsStatus.clientDeletionFailure));
    }
  }

  Future<void> _onReloadRequested(
    ClientsReloadRequested event,
    Emitter<ClientsState> emit,
  ) async =>
      await _onLoadRequested(emit);

  Future<void> _onLoadRequested(Emitter<ClientsState> emit) async {
    emit(state.copyWith(status: () => ClientsStatus.loading));

    await emit.forEach<List<Client>>(
      _clientsRepository.getClients(),
      onData: (clients) => state.copyWith(
        status: () => clients.isNotEmpty ? ClientsStatus.success : ClientsStatus.emptyList,
        clients: () => clients,
      ),
      onError: (_, __) => state.copyWith(
        status: () => ClientsStatus.failure,
      ),
    );
  }
}
