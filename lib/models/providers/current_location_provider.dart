import '../user_location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../../models/weather_forecast.dart';

class CurrentLocationProvider extends ChangeNotifier {
  UserLocation? _currentLocation;
  bool _isHourly = true;
  List<WeatherForecast>? _forecasts;

  CurrentLocationProvider();

  void setCurrentLocation(UserLocation currentLocation) async {
    _currentLocation = currentLocation;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("location", _currentLocation?.toJsonString() ?? "");
    updateForecasts();
    notifyListeners();
  }

  void setHourly(bool isHourly) async {
    _isHourly = isHourly;
    updateForecasts();
    notifyListeners();
  }

  static Future<CurrentLocationProvider> create() async {
    CurrentLocationProvider clp = CurrentLocationProvider();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String locationString = sharedPreferences.getString("location") ?? "";
    clp._currentLocation = UserLocation.fromJsonString(locationString);
    clp.updateForecasts();
    return clp;
  }

  List<WeatherForecast> getWeatherForecastList() {
    return [...(_forecasts ?? [])];
  }

  UserLocation getCurrentLocation() {
    return _currentLocation!;
  }

  void updateForecasts() async {
    _forecasts = await getWeatherForecasts(_currentLocation!, _isHourly);
  }
}