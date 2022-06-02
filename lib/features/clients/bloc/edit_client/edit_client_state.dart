part of 'edit_client_bloc.dart';

enum EditClientStatus {
  initial,
  editing,
}

class EditClientState extends Equatable {
  const EditClientState({
    this.status = EditClientStatus.initial,
    this.editedClients = const {},
    this.duplicatedNameErrors = const <String>{},
  });

  final EditClientStatus status;
  final Map<String, Client> editedClients;
  final Set<String> duplicatedNameErrors;

  EditClientState copyWith({
    EditClientStatus Function()? status,
    Map<String, Client> Function()? editedClients,
    Set<String> Function()? duplicatedNameErrors,
  }) =>
      EditClientState(
        status: status != null ? status() : this.status,
        editedClients: editedClients != null ? editedClients() : this.editedClients,
        duplicatedNameErrors: duplicatedNameErrors != null ? duplicatedNameErrors() : this.duplicatedNameErrors,
      );

  @override
  List<Object?> get props => [
        status,
        editedClients,
        duplicatedNameErrors,
      ];
}
