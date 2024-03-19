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
    await updateForecasts();
    notifyListeners();
  }

  void setHourly(bool isHourly) async {
    _isHourly = isHourly;
    await updateForecasts();
    print("set hourly to $isHourly");
    notifyListeners();
  }

  void toggleHourly() async {
    setHourly(!_isHourly);
  }

  bool isHourly() {
    return _isHourly;
  }

  static Future<CurrentLocationProvider> create() async {
    CurrentLocationProvider clp = CurrentLocationProvider();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String locationString = sharedPreferences.getString("location") ?? "";
    clp._currentLocation = UserLocation.fromJsonString(locationString);
    await clp.updateForecasts();
    return clp;
  }

  List<WeatherForecast> getWeatherForecastList() {
    if (_forecasts == null) { 
      print("forecast list null");

    }
    return _forecasts ?? [];
  }

  UserLocation getCurrentLocation() {
    return _currentLocation!;
  }

  Future<void> updateForecasts() async {
    _forecasts = await getWeatherForecasts(_currentLocation!, _isHourly);
    notifyListeners();
    // return Future.value(void);
  }
}