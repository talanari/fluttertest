import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clients_repository/clients_repository.dart';
import 'package:fluttertest/constants/constants.dart';
import 'package:fluttertest/features/report/report.dart';
import 'package:fluttertest/shared_widgets/small_text.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportBloc(
        clientsRepository: context.read<ClientsRepository>(),
      )..add(const ReportSubscriptionRequested()),
      child: const ReportView(),
    );
  }
}

class ReportView extends StatelessWidget {
  const ReportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Отчет по городам'),
      ),
      body: BlocConsumer<ReportBloc, ReportState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == ReportStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Ошибка загрузки отчета'),
                ),
              );
          }
        },
        builder: (context, state) {
          switch (state.status) {
            case ReportStatus.initial:
              return const SizedBox();
            case ReportStatus.loading:
              return const Center(child: CupertinoActivityIndicator());
            case ReportStatus.emptyList:
              return Center(
                child: Text(
                  'Нет данных для построения отчета',
                  style: Theme.of(context).textTheme.caption,
                ),
              );
            case ReportStatus.success:
              final tableWidth =
                  MediaQuery.of(context).size.width - UI.dataTableHorizontalMargins * 2 - UI.dataTableColumnSpacing * 3;

              return DataTable(
                columnSpacing: UI.dataTableColumnSpacing,
                horizontalMargin: UI.dataTableHorizontalMargins,
                columns: const [
                  DataColumn(label: SmallText('Город')),
                  DataColumn(
                    label: Expanded(
                      child: SmallText(
                        'Сумма покупок',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
                rows: state.expensesByCity
                    .map((city) => DataRow(
                          cells: [
                            DataCell(
                              SizedBox(
                                width: tableWidth * 0.4,
                                child: SmallText(city.city),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: tableWidth * 0.6,
                                child: SmallText(
                                  city.expenses.toString(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              );
            case ReportStatus.failure:
              return Center(
                child: ElevatedButton(
                  onPressed: () => context.read<ReportBloc>().add(const ReportReloadRequested()),
                  child: const Text('Обновить'),
                ),
              );
          }
        },
      ),
    );
  }
}
