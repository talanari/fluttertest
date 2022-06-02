part of 'home_cubit.dart';

enum HomeTab {
  clients,
  report,
}

class HomeState extends Equatable {
  const HomeState({
    this.tab = HomeTab.clients,
  });

  final HomeTab tab;

  @override
  List<Object> get props => [tab];
}
