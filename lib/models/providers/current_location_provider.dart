import '../user_location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class CurrentLocationProvider extends ChangeNotifier {
  UserLocation? _currentLocation;

  CurrentLocationProvider();

  void setCurrentLocation(UserLocation currentLocation) async {
    _currentLocation = currentLocation;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("location", _currentLocation?.toJsonString() ?? "");
    notifyListeners();
  }

  static Future<CurrentLocationProvider> create() async {
    CurrentLocationProvider clp = CurrentLocationProvider();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String locationString = sharedPreferences.getString("location") ?? "";
    clp._currentLocation = UserLocation.fromJsonString(locationString);
    return clp;
  }
}