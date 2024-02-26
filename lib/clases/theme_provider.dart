import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  late ThemeData _themeData;

  ThemeProvider() {
    _themeData = ThemeData.light().copyWith(primaryColor: Colors.green);
    _loadThemeFromPrefs();
  }

  ThemeData get themeData => _themeData;

  void toggleTheme() {
    _themeData = _themeData.brightness == Brightness.light
        ? ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.green, // Color primario oscuro
              secondary: Colors.green, // Color secundario oscuro
            ),
            textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: Colors.white, // Color del texto principal oscuro
              displayColor: Colors.white, // Color del texto de pantalla oscuro
            ),
            iconTheme: ThemeData.dark().iconTheme.copyWith(
              color: Colors.white, // Color de los iconos oscuros
            ),
            
          )
        : ThemeData.light().copyWith(
            primaryColor: Colors.green, // Color primario claro
            textTheme: ThemeData.light().textTheme.apply(
              bodyColor: Colors.black, // Color del texto principal claro
              displayColor: Colors.black, // Color del texto de pantalla claro
            ),
            iconTheme: ThemeData.light().iconTheme.copyWith(
              color: Colors.black, // Color de los iconos claros
            ),
          );

    _saveThemeToPrefs();
    notifyListeners();
  }

  Future<void> _loadThemeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isDarkMode = prefs.getBool('isDarkMode');
    if (isDarkMode != null && isDarkMode) {
      toggleTheme(); // Si el modo oscuro está activado, cambia al modo oscuro
    }
  }

  Future<void> _saveThemeToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _themeData.brightness == Brightness.dark);
  }
}
