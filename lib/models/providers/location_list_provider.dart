import '../user_location.dart';
import '../location_database.dart';
import 'package:flutter/material.dart';

class LocationListProvider extends ChangeNotifier {
  late List<UserLocation> _locationList;
  late LocationDatabase db;

  void addLocation(UserLocation userLocation) {
    _locationList.add(userLocation);
    db.insertLocation(userLocation);
    notifyListeners();
  }

  static Future<LocationListProvider> create() async {
    LocationListProvider llp = LocationListProvider();
    llp.db = await LocationDatabase.open();
    llp._locationList = await llp.db.getLocations();
    return llp;
  }
}