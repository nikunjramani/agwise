import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    visualDensity: VisualDensity(vertical: 0.5, horizontal: 0.5),

    primaryColor:Color.fromRGBO(12,177,75,.9),
    primaryColorBrightness: Brightness.light,
    primaryColorLight: Color(0x1aF5E0C3),
    primaryColorDark: Color(0xff936F3E),
    canvasColor: Color(0xffE09E45),
    accentColor: Colors.white,
    accentColorBrightness: Brightness.light,
    scaffoldBackgroundColor: Color(0xffB5BFD3),
    bottomAppBarColor: Color(0xff6D42CE),
    cardColor: Color(0xaaF5E0C3),
    buttonTheme: ButtonThemeData(
        buttonColor: Color.fromRGBO(12,177,75,.9),
        shape: RoundedRectangleBorder(),
        textTheme: ButtonTextTheme.accent,
     ),
    dividerColor: Color(0x1f6D42CE),
    focusColor: Color(0x1aF5E0C3)
);
