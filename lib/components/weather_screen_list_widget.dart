
import '../../models/providers/current_location_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_location.dart';

class WeatherScreenListWidget extends StatelessWidget {
  const WeatherScreenListWidget({super.key});
  @override
  Widget build(BuildContext context) {
    // Needs current location + hourly bool. 
    UserLocation userLocation = Provider.of<CurrentLocationProvider>(context, listen: false).getCurrentLocation();
    return Text(userLocation.toJsonString());
  }
}