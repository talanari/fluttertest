import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clients_api/clients_api.dart';
import 'package:clients_repository/clients_repository.dart';

part 'edit_client_event.dart';
part 'edit_client_state.dart';

class EditClientBloc extends Bloc<EditClientEvent, EditClientState> {
  EditClientBloc({
    required ClientsRepository clientsRepository,
  })  : _clientsRepository = clientsRepository,
        super(const EditClientState()) {
    on<EditClientSubscriptionRequested>(_onSubscriptionRequested);
    on<EditClientEditing>(_onClientEditing);
    on<EditClientCreated>(_onClientCreated);
    on<EditClientSaved>(_onClientSaved);
  }

  final ClientsRepository _clientsRepository;

  Future<void> _onSubscriptionRequested(
    EditClientSubscriptionRequested event,
    Emitter<EditClientState> emit,
  ) async {
    emit(state.copyWith(status: () => EditClientStatus.editing));
  }

  void _onClientEditing(
    EditClientEditing event,
    Emitter<EditClientState> emit,
  ) =>
      emit(state.copyWith(
        editedClients: () => {...state.editedClients}..[event.client.id ?? 'New'] = event.client,
      ));

  Future<void> _onClientCreated(
    EditClientCreated event,
    Emitter<EditClientState> emit,
  ) async {
    try {
      await _clientsRepository.createClient(event.client
        ..name.trim()
        ..city.trim());
      emit(state.copyWith(
        duplicatedNameErrors: () => {...state.duplicatedNameErrors}..remove('New'),
        editedClients: () => {...state.editedClients}..remove('New'),
      ));
    } on ClientNameDuplicateException {
      emit(state.copyWith(
        duplicatedNameErrors: () => {...state.duplicatedNameErrors}..add('New'),
      ));
    }
  }

  Future<void> _onClientSaved(
    EditClientSaved event,
    Emitter<EditClientState> emit,
  ) async {
    try {
      await _clientsRepository.saveClient(event.client
        ..name.trim()
        ..city.trim());
      emit(state.copyWith(
        duplicatedNameErrors: () => {...state.duplicatedNameErrors}..remove(event.client.id),
        editedClients: () => {...state.editedClients}..remove(event.client.id),
      ));
    } on ClientNameDuplicateException {
      emit(state.copyWith(
        duplicatedNameErrors: () => {...state.duplicatedNameErrors}..add(event.client.id!),
      ));
    }
  }
}
