
import '../user_location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../../models/weather_forecast.dart';

class ThemeProvider extends ChangeNotifier {
  bool? _light;

  ThemeProvider();

  static Future<ThemeProvider> create() async {
    ThemeProvider tp = ThemeProvider();
    tp._light = (await SharedPreferences.getInstance()).getBool("light") ?? true;
    return tp;
  }

  bool isLight() {
    return _light!;
  }

  ThemeMode themeMode() {
    if (_light == true) {
      return ThemeMode.light;
    } else {
      return ThemeMode.dark;
    }
  }

  void setLight(bool value) async {
    _light = value;
    (await SharedPreferences.getInstance()).setBool("light", value);
    notifyListeners();
  }
}