import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clients_api/clients_api.dart';
import 'package:clients_repository/clients_repository.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc({
    required ClientsRepository clientsRepository,
  })  : _clientsRepository = clientsRepository,
        super(const ReportState()) {
    on<ReportSubscriptionRequested>(_onSubscriptionRequested);
    on<ReportReloadRequested>(_onReloadRequested);
  }

  final ClientsRepository _clientsRepository;

  Future<void> _onSubscriptionRequested(
    ReportSubscriptionRequested event,
    Emitter<ReportState> emit,
  ) async =>
      await _onLoadRequested(emit);

  Future<void> _onReloadRequested(
    ReportReloadRequested event,
    Emitter<ReportState> emit,
  ) async =>
      await _onLoadRequested(emit);

  Future<void> _onLoadRequested(Emitter<ReportState> emit) async {
    emit(state.copyWith(status: () => ReportStatus.loading));

    await emit.forEach<List<ExpensesByCity>>(
      _clientsRepository.getClientsExpensesByCity(),
      onData: (expensesByCity) => state.copyWith(
        status: () => expensesByCity.isNotEmpty ? ReportStatus.success : ReportStatus.emptyList,
        expensesByCity: () => expensesByCity,
      ),
      onError: (_, __) => state.copyWith(
        status: () => ReportStatus.failure,
      ),
    );
  }
}
