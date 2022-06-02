import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluttertest/constants/constants.dart';
import 'package:fluttertest/features/clients/clients.dart';

class ClientsDataCellInput extends StatelessWidget {
  const ClientsDataCellInput({
    Key? key,
    required this.onChanged,
    required this.onTap,
    this.errorText,
    this.initialValue,
    this.inputFormatters,
    this.placeholder,
    this.width,
    this.keyboardType = TextInputType.name,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  final String? errorText;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;
  final GestureTapCallback onTap;
  final String? placeholder;
  final TextAlign textAlign;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditClientBloc, EditClientState>(
      builder: (editContext, editState) => SizedBox(
        width: width,
        child: TextFormField(
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            errorText: errorText,
            filled: false,
            hintStyle: const TextStyle(fontSize: UI.smallTextFontSize),
            hintText: placeholder,
          ),
          initialValue: initialValue,
          inputFormatters: inputFormatters,
          keyboardType: keyboardType,
          maxLines: null,
          onChanged: onChanged,
          onTap: onTap,
          style: const TextStyle(fontSize: UI.smallTextFontSize),
          textAlign: textAlign,
        ),
      ),
    );
  }
}
