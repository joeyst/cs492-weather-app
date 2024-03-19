
import '../../models/providers/current_location_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_location.dart';
import '../../models/weather_forecast.dart';
import './weather_screen_list_item_widget.dart';

class WeatherScreenListWidget extends StatelessWidget {
  const WeatherScreenListWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final currentLocationProvider = Provider.of<CurrentLocationProvider>(context);
    List<WeatherForecast> forecasts = currentLocationProvider.getWeatherForecastList();
    print("forecasts: ${forecasts.map((forecast) => "${forecast.toJsonString()}\n").toList()}");
    List<WeatherForecastListItemWidget> forecastWidgets = forecasts.map((forecast) => WeatherForecastListItemWidget(forecast)).toList();
    return ListView(
      children: forecastWidgets,
    );
    // return Consumer<CurrentLocationProvider>(
    //   builder: (context, currentLocationProvider, child) {
    //     List<WeatherForecast> forecasts = currentLocationProvider.getWeatherForecastList();
    //     UserLocation currentLocation = currentLocationProvider.getCurrentLocation();
    //     return Text(currentLocation.toJsonString());

        /*
        // Needs current location + hourly bool. 
        UserLocation userLocation = Provider.of<CurrentLocationProvider>(context, listen: false).getCurrentLocation();
        return Text(userLocation.toJsonString());
        */
    //   },
    // );
  }
}