part of 'edit_client_bloc.dart';

abstract class EditClientEvent extends Equatable {
  const EditClientEvent();

  @override
  List<Object> get props => [];
}

class EditClientSubscriptionRequested extends EditClientEvent {
  const EditClientSubscriptionRequested();
}

class EditClientEditing extends EditClientEvent {
  const EditClientEditing(this.client);

  final Client client;

  @override
  List<Object> get props => [client];
}

class EditClientCreated extends EditClientEvent {
  const EditClientCreated(this.client);

  final Client client;

  @override
  List<Object> get props => [client];
}

class EditClientSaved extends EditClientEvent {
  const EditClientSaved(this.client);

  final Client client;

  @override
  List<Object> get props => [client];
}
