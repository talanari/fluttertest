part of 'report_bloc.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object> get props => [];
}

class ReportSubscriptionRequested extends ReportEvent {
  const ReportSubscriptionRequested();
}

class ReportReloadRequested extends ReportEvent {
  const ReportReloadRequested();
}
