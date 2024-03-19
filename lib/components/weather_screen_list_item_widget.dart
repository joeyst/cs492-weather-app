
import 'package:flutter/material.dart';
import '../models/weather_forecast.dart';


class WeatherForecastListItemWidget extends StatelessWidget {
  final WeatherForecast weatherForecast;
  const WeatherForecastListItemWidget(this.weatherForecast, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(weatherForecast.name),
      subtitle: Text(weatherForecast.temperature.toString()),
      trailing: Text(weatherForecast.temperature.toString()),
    );
  }
}