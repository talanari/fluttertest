import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FlutterTestTheme {
  static ThemeData get light => FlexThemeData.light(
        scheme: FlexScheme.brandBlue,
        fontFamily: GoogleFonts.rubik().fontFamily,
      );

  static ThemeData get dark => FlexThemeData.dark(
        scheme: FlexScheme.brandBlue,
        fontFamily: GoogleFonts.rubik().fontFamily,
      );
}
