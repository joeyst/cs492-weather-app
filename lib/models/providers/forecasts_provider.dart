
import 'package:flutter/material.dart';
import '../weather_forecast.dart';

class WeatherForecastProvider extends ChangeNotifier {
  bool hourly = true; // hourly vs twice daily 
  late List<WeatherForecast> _forecasts;

  WeatherForecastProvider();

  static Future<WeatherForecastProvider> create() async {
    WeatherForecastProvider wfp = WeatherForecastProvider();
    wfp._forecasts = await getWeatherForecasts(
  }
}