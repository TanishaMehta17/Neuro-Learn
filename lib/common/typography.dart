import 'package:flutter/material.dart';
import 'colors.dart';

/// Font Size
class SCRTypography {
  static const TextStyle heading = TextStyle(
    fontFamily: 'SFProDisplay',
    color: black10,
    fontSize: 25, // Material Design 3 convention
    fontWeight: FontWeight.w700,
  );
  static const TextStyle heading1 = TextStyle(
    fontFamily: 'SFProDisplay',
    color: white,
    fontSize: 22, // Material Design 3 convention
    fontWeight: FontWeight.w700,
  );
  static const TextStyle subHeading = TextStyle(
    fontFamily: 'SFProDisplay',
    color: grey,
    fontSize: 16, // Material Design 3 convention
    fontWeight: FontWeight.w400,
  );
   static const TextStyle h1 = TextStyle(
    fontFamily: 'SCTFont',
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'SCTFont',
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle button = TextStyle(
    fontFamily: 'SCTFont',
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
}
