import 'package:flutter/material.dart';

class Palette {
  static const primaryColor = Color(0xFFC52127);
  static const backgroundColor = Color(0xFFF6F6F6);
  static const cardColor = Color.fromRGBO(233, 236, 239, 1.0);
  static const appBarColor = Colors.white;
  static const buttonColor = Color(0xFFC52127);
  static const borderColor = Color.fromRGBO(33, 37, 41, 1.0);
  static const textColor = Colors.black;
  static const blackColor = Colors.black;
  static const iconColor = Colors.black;
  // static const appBarIconColor = Color.fromRGBO(231, 236, 239, 1.0);
  static const buttonTextColor = Color.fromRGBO(231, 236, 239, 1.0);
  static const hintTextColor = Color.fromRGBO(139, 140, 137, 1.0);
  static const snackBarErrorColor = Colors.red;
  static const snackBarSuccessColor = Colors.green;

  static var lightModeAppTheme = ThemeData.light(useMaterial3: true).copyWith(
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      color: backgroundColor,
      // iconTheme: IconThemeData(color: appBarIconColor),
      titleTextStyle: TextStyle(
        color: textColor,
        fontSize: 20,
      ),
    ),
    iconTheme: const IconThemeData(
      size: 30,
      color: iconColor,
    ),
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStatePropertyAll(iconColor),
      ),
    ),
    cardTheme: const CardTheme(
      color: cardColor,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        backgroundColor: const MaterialStatePropertyAll(buttonColor),
        foregroundColor: const MaterialStatePropertyAll(buttonTextColor),
        fixedSize: const MaterialStatePropertyAll(
          Size(100, 50),
        ),
      ),
    ),
  );
}
