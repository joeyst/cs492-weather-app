
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
    bool isHourly = currentLocationProvider.isHourly();
    Widget title = Text("${isHourly ? 'Hourly' : 'Daily'} | ${currentLocationProvider.getCurrentLocation().name()}");
    WeatherForecast mainForecast = forecasts.removeAt(0);
    Widget mainForecastWidget = WeatherForecastListItemWidget(mainForecast, isMain: true);
    List<WeatherForecastListItemWidget> forecastWidgets = forecasts.map((forecast) => WeatherForecastListItemWidget(forecast)).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
      title,
      SizedBox(height: 1000, child: ListView(
        children: [mainForecastWidget, ...forecastWidgets],
      )),
      ]
    );
  }
}