import 'package:flutter/material.dart';

//used for theming purposes
MaterialColor PrimaryMaterialColor = MaterialColor(
  4282496510,
  <int, Color>{
    50: Color.fromRGBO(
      65,
      181,
      254,
      .1,
    ),
    100: Color.fromRGBO(
      65,
      181,
      254,
      .2,
    ),
    200: Color.fromRGBO(
      65,
      181,
      254,
      .3,
    ),
    300: Color.fromRGBO(
      65,
      181,
      254,
      .4,
    ),
    400: Color.fromRGBO(
      65,
      181,
      254,
      .5,
    ),
    500: Color.fromRGBO(
      65,
      181,
      254,
      .6,
    ),
    600: Color.fromRGBO(
      65,
      181,
      254,
      .7,
    ),
    700: Color.fromRGBO(
      65,
      181,
      254,
      .8,
    ),
    800: Color.fromRGBO(
      65,
      181,
      254,
      .9,
    ),
    900: Color.fromRGBO(
      65,
      181,
      254,
      1,
    ),
  },
);

ThemeData myTheme = ThemeData(
  fontFamily: "customFont",
  primaryColor: Color(0xff41b5fe),
  buttonColor: Color(0xff41b5fe),
  accentColor: Color(0xff41b5fe),
  primarySwatch: PrimaryMaterialColor,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
        Color(0xff41b5fe),
      ),
    ),
  ),
);
