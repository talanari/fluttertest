import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clients_repository/clients_repository.dart';
import 'package:fluttertest/constants/constants.dart';
import 'package:fluttertest/features/clients/clients.dart';
import 'package:fluttertest/shared_widgets/small_text.dart';
import 'package:fluttertest/utils/comma_text_input_formatter.dart';

import 'clients_data_cell_input.dart';

class ClientsDataTable extends StatelessWidget {
  const ClientsDataTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tableWidth =
        MediaQuery.of(context).size.width - UI.dataTableHorizontalMargins * 2 - UI.dataTableColumnSpacing * 3;

    return BlocProvider(
      create: (context) => EditClientBloc(
        clientsRepository: context.read<ClientsRepository>(),
      )..add(const EditClientSubscriptionRequested()),
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(width: MediaQuery.of(context).size.width),
        child: SingleChildScrollView(
          child: BlocBuilder<ClientsBloc, ClientsState>(
            builder: (context, state) => BlocBuilder<EditClientBloc, EditClientState>(
              builder: (editContext, editState) => DataTable(
                columnSpacing: UI.dataTableColumnSpacing,
                horizontalMargin: UI.dataTableHorizontalMargins,
                columns: const [
                  DataColumn(label: SmallText('Имя')),
                  DataColumn(label: SmallText('Город')),
                  DataColumn(
                    label: Expanded(
                      child: SmallText(
                        'Сумма покупок',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataColumn(label: SizedBox()),
                ],
                rows: state.clients
                    .map((client) => DataRow(
                          selected: editState.editedClients.containsKey(client.id),
                          cells: [
                            DataCell(
                              ClientsDataCellInput(
                                key: Key('__${client.id!}_name_data_table_input__'),
                                errorText:
                                    editState.duplicatedNameErrors.contains(client.id) ? 'Имя уже существует' : null,
                                initialValue: client.name,
                                onChanged: (name) => context
                                    .read<EditClientBloc>()
                                    .add(EditClientEditing(editState.editedClients[client.id]!.copyWith(name: name))),
                                onTap: () => context.read<EditClientBloc>().add(
                                    editState.editedClients[client.id] == null
                                        ? EditClientEditing(client)
                                        : EditClientEditing(editState.editedClients[client.id]!)),
                                width: tableWidth * 0.4,
                              ),
                            ),
                            DataCell(
                              ClientsDataCellInput(
                                key: Key('__${client.id!}_city_data_table_input__'),
                                initialValue: client.city,
                                onChanged: (city) => context
                                    .read<EditClientBloc>()
                                    .add(EditClientEditing(editState.editedClients[client.id]!.copyWith(city: city))),
                                onTap: () => context.read<EditClientBloc>().add(
                                    editState.editedClients[client.id] == null
                                        ? EditClientEditing(client)
                                        : EditClientEditing(editState.editedClients[client.id]!)),
                                width: tableWidth * 0.2,
                              ),
                            ),
                            DataCell(
                              ClientsDataCellInput(
                                key: Key('__${client.id!}_expenses_data_table_input__'),
                                initialValue: client.expenses.toString(),
                                inputFormatters: [
                                  FilteringTextInputFormatter(RegExp(Formatters.expenses), allow: true),
                                  CommaTextInputFormatter(),
                                ],
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                onChanged: (expenses) => context.read<EditClientBloc>().add(EditClientEditing(editState
                                    .editedClients[client.id]!
                                    .copyWith(expenses: expenses != '' ? double.parse(expenses) : null))),
                                onTap: () => context.read<EditClientBloc>().add(
                                    editState.editedClients[client.id] == null
                                        ? EditClientEditing(client)
                                        : EditClientEditing(editState.editedClients[client.id]!)),
                                placeholder: 'и сумму',
                                textAlign: TextAlign.center,
                                width: tableWidth * 0.3,
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: tableWidth * 0.1,
                                child: editState.editedClients[client.id] == null
                                    ? IconButton(
                                        icon: const Icon(
                                          Icons.delete_forever_rounded,
                                          size: 17,
                                        ),
                                        onPressed: () {
                                          context.read<ClientsBloc>().add(ClientsClientDeleted(client));
                                          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                                        },
                                      )
                                    : IconButton(
                                        icon: const Icon(
                                          Icons.check,
                                          size: 17,
                                        ),
                                        onPressed: () {
                                          context
                                              .read<EditClientBloc>()
                                              .add(EditClientSaved(editState.editedClients[client.id]!));
                                          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                                        },
                                      ),
                              ),
                            ),
                          ],
                        ))
                    .toList()
                  ..add(DataRow(
                    cells: [
                      DataCell(
                        ClientsDataCellInput(
                          key: const Key('__New_name_data_table_input__'),
                          errorText: editState.duplicatedNameErrors.contains('New') ? 'Имя уже существует' : null,
                          initialValue:
                              editState.editedClients['New'] != null ? editState.editedClients['New']!.name : null,
                          onChanged: (name) => context
                              .read<EditClientBloc>()
                              .add(EditClientEditing(editState.editedClients['New']!.copyWith(name: name))),
                          onTap: () => context.read<EditClientBloc>().add(editState.editedClients['New'] == null
                              ? EditClientEditing(Client(name: ''))
                              : EditClientEditing(editState.editedClients['New']!)),
                          placeholder: 'Введите имя (*)',
                          width: tableWidth * 0.4,
                        ),
                      ),
                      DataCell(
                        ClientsDataCellInput(
                          key: const Key('__New_city_data_table_input__'),
                          onChanged: (city) => context
                              .read<EditClientBloc>()
                              .add(EditClientEditing(editState.editedClients['New']!.copyWith(city: city))),
                          onTap: () => context.read<EditClientBloc>().add(editState.editedClients['New'] == null
                              ? EditClientEditing(Client(name: ''))
                              : EditClientEditing(editState.editedClients['New']!)),
                          placeholder: 'город',
                          width: tableWidth * 0.2,
                        ),
                      ),
                      DataCell(
                        ClientsDataCellInput(
                          key: const Key('__New_expenses_data_table_input__'),
                          inputFormatters: [
                            FilteringTextInputFormatter(RegExp(Formatters.expenses), allow: true),
                            CommaTextInputFormatter(),
                          ],
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (expenses) => context.read<EditClientBloc>().add(EditClientEditing(editState
                              .editedClients['New']!
                              .copyWith(expenses: expenses != '' ? double.parse(expenses) : null))),
                          onTap: () => context.read<EditClientBloc>().add(editState.editedClients['New'] == null
                              ? EditClientEditing(Client(name: ''))
                              : EditClientEditing(editState.editedClients['New']!)),
                          placeholder: 'и сумму',
                          textAlign: TextAlign.center,
                          width: tableWidth * 0.3,
                        ),
                      ),
                      DataCell(
                        editState.editedClients['New'] == null || editState.editedClients['New']!.name == ''
                            ? SizedBox(width: tableWidth * 0.1)
                            : SizedBox(
                                width: tableWidth * 0.1,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.check,
                                    size: 17,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<EditClientBloc>()
                                        .add(EditClientCreated(editState.editedClients['New']!));
                                    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                                  },
                                ),
                              ),
                      ),
                    ],
                  )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
