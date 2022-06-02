part of 'clients_bloc.dart';

enum ClientsStatus {
  initial,
  loading,
  emptyList,
  success,
  failure,
  clientDeletionFailure,
}

class ClientsState extends Equatable {
  const ClientsState({
    this.status = ClientsStatus.initial,
    this.clients = const [],
  });

  final ClientsStatus status;
  final List<Client> clients;

  ClientsState copyWith({
    ClientsStatus Function()? status,
    List<Client> Function()? clients,
  }) =>
      ClientsState(
        status: status != null ? status() : this.status,
        clients: clients != null ? clients() : this.clients,
      );

  @override
  List<Object?> get props => [
        status,
        clients,
      ];
}
