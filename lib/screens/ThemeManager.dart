import 'package:flutter/material.dart';
import 'package:sca/Service/SharedData.dart';

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData(
      primaryColor: Colors.black,
      brightness: Brightness.dark,
      backgroundColor: const Color(0xFF212121),
      accentColor: Colors.white,
      accentIconTheme: IconThemeData(color: Colors.black),
      dividerColor: Colors.black12,
      textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white));

  final lightTheme = ThemeData(
      primaryColor: Color(0xFFFF5E03),
      brightness: Brightness.light,
      unselectedWidgetColor: Color(0xFFFF5E03),
      textSelectionTheme:
          TextSelectionThemeData(cursorColor: Color(0xFFFF5E03)));

  ThemeData _themeData;
  ThemeData getTheme() => _themeData;

  ThemeNotifier() {
    SharedData.getThemeMode().then((value) {
      print('value read from storage: ' + value.toString());
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _themeData = lightTheme;
      } else {
        print('setting dark theme');
        _themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    SharedData.setThemeMode('dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    SharedData.setThemeMode('light');
    notifyListeners();
  }
}
