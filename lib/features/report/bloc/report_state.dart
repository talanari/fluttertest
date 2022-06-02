part of 'report_bloc.dart';

enum ReportStatus {
  initial,
  loading,
  emptyList,
  success,
  failure,
}

class ReportState extends Equatable {
  const ReportState({
    this.status = ReportStatus.initial,
    this.expensesByCity = const [],
  });

  final ReportStatus status;
  final List<ExpensesByCity> expensesByCity;

  ReportState copyWith({
    ReportStatus Function()? status,
    List<ExpensesByCity> Function()? expensesByCity,
  }) =>
      ReportState(
        status: status != null ? status() : this.status,
        expensesByCity: expensesByCity != null ? expensesByCity() : this.expensesByCity,
      );

  @override
  List<Object?> get props => [
        status,
        expensesByCity,
      ];
}
