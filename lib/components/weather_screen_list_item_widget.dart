
import 'package:flutter/material.dart';
import '../models/weather_forecast.dart';
import 'package:provider/provider.dart';
import '../models/providers/current_location_provider.dart';

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
    Widget weatherIcon = Image.asset(imagePath, width: 100, height: 100, fit: BoxFit.cover);
    Widget titleWidgetBox = SizedBox(
      width: 100,
      height: 100,
      child: titleWidget,
    );


    List<Widget> children = [];
    if (!Provider.of<CurrentLocationProvider>(context).isHourly()) {
      children.add(titleWidgetBox);
    }

    children.add(weatherIcon);

    Row row = Row(
      children: children,
    );

    return ListTile(
      title: row,
      subtitle: Text("F: ${weatherForecast.temperature.toString()}"),
      // trailing: Text(weatherForecast.temperature.toString()),
    );
  }
}