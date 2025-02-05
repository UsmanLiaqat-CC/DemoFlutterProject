import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'AppColor.dart';
import 'AppFonts.dart';


class ThemeCollection {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColor.secoundryColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      actionsIconTheme: IconThemeData(color: Colors.black),
      iconTheme: IconThemeData(color: Colors.black),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColor.primaryColor,
    primarySwatch:Colors.blue,
    primaryColorDark:AppColor.primaryDarkColor,
    scaffoldBackgroundColor:AppColor.scafooldColor,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.white,
      actionsIconTheme: IconThemeData(color: Colors.black),
      iconTheme: IconThemeData(color: Colors.black),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
    textTheme:  TextTheme(
      titleLarge: StyleRefer.poppinsBold,
      titleSmall: StyleRefer.poppinsRegular,
      titleMedium: StyleRefer.poppinsMedium
    ),
  );
}