
import 'package:flutter/material.dart';
import '../models/weather_forecast.dart';


class WeatherForecastListItemWidget extends StatelessWidget {
  final WeatherForecast weatherForecast;
  const WeatherForecastListItemWidget(this.weatherForecast, {super.key});

  @override
  Widget build(BuildContext context) {
    
    Widget titleWidget = Text("Name: ${weatherForecast.name}");
    String iconName = "summer";
    if (weatherForecast.temperature % 2 == 0) {
      iconName = "winter";
    }
    // else if (weatherForcast.
      
    String imagePath = "assets/weather_icons/${iconName}_furby.jpg";
    

    // String imagePath = 'assets/images/${weatherForecast.icon}.png';
    Widget weatherIcon = Image.asset(imagePath);
    Row row = Row(
      children: [
        weatherIcon,
        titleWidget,
      ],
    );
    return ListTile(
      title: row,
      subtitle: Text("temperature: ${weatherForecast.temperature.toString()}"),
      trailing: Text(weatherForecast.temperature.toString()),
    );
  }
}