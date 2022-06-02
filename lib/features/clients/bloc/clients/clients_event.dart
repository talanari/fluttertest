part of 'clients_bloc.dart';

abstract class ClientsEvent extends Equatable {
  const ClientsEvent();

  @override
  List<Object> get props => [];
}

class ClientsSubscriptionRequested extends ClientsEvent {
  const ClientsSubscriptionRequested();
}

class ClientsFirstClientAdded extends ClientsEvent {
  const ClientsFirstClientAdded();
}

class ClientsClientDeleted extends ClientsEvent {
  const ClientsClientDeleted(this.client);

  final Client client;

  @override
  List<Object> get props => [client];
}

class ClientsReloadRequested extends ClientsEvent {
  const ClientsReloadRequested();
}
