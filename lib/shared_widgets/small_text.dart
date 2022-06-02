import 'package:flutter/material.dart';

import 'package:fluttertest/constants/constants.dart';

class SmallText extends StatelessWidget {
  const SmallText(
    this.text, {
    Key? key,
    this.fontStyle,
    this.fontWeight,
    this.textAlign,
    this.decoration = TextDecoration.none,
  }) : super(key: key);

  final TextDecoration? decoration;
  final FontStyle? fontStyle;
  final FontWeight? fontWeight;
  final String text;
  final TextAlign? textAlign;

  @override
  Widget build(context) => Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          decoration: decoration,
          fontSize: UI.smallTextFontSize,
          fontStyle: fontStyle ?? FontStyle.normal,
          fontWeight: fontWeight ?? FontWeight.w400,
        ),
        textAlign: textAlign ?? TextAlign.start,
      );
}
