
import 'package:flutter/material.dart';
import '../models/weather_forecast.dart';
import 'package:provider/provider.dart';
import '../models/providers/current_location_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class WeatherForecastListItemWidget extends StatelessWidget {
  final WeatherForecast weatherForecast;
  final bool isMain;
  const WeatherForecastListItemWidget(this.weatherForecast, {this.isMain=false, super.key});

  @override
  Widget build(BuildContext context) {
    
    TextStyle textStyle = GoogleFonts.getFont("Roboto");
    if (isMain) {
      // TextStyle textStyle = GoogleFonts.getFont("Roboto", fontSize: 50.0, fontWeight: FontWeight.bold);
    }

    Widget titleWidget = Text(weatherForecast.name, style: textStyle);
    String iconName = "summer";
    if (weatherForecast.temperature % 2 == 0) {
      iconName = "winter";
    }
    // else if (weatherForcast.
      
    String imagePath = "assets/weather_icons/${iconName}_furby.jpg";
    

    // String imagePath = 'assets/images/${weatherForecast.icon}.png';
    double iconSize = 100;
    if (isMain) {
      iconSize = 200;
    }

    

    Widget weatherIcon = Image.asset(imagePath, width: iconSize, height: iconSize, fit: BoxFit.cover);
    Widget titleWidgetBox = SizedBox(
      width: 100,
      height: 100,
      child: titleWidget,
    );


    List<Widget> children = [];
    // if (isMain) {
      children.add(weatherIcon);
    //}
    String forecastText = weatherForecast.shortForecast;
    if (!Provider.of<CurrentLocationProvider>(context).isHourly()) {
      children.add(titleWidgetBox);
      forecastText = weatherForecast.detailedForecast;
    }

    // children.add(weatherIcon);
    
    Row row = Row(children: children);
    Widget temperatureText = Text("F: ${weatherForecast.temperature.toString()}", style: textStyle);

    children.add(temperatureText);

    if (isMain) {
      return ListTile(
        title: row,
        subtitle: Text(forecastText, style: textStyle),
        trailing: Column(children: [SizedBox(width: 300, height: 65, child: weatherIcon), Text("The people have sharp eyes", style: TextStyle(fontSize: 6.9420, color: Colors.red, fontStyle: FontStyle.italic))]),
      );
    } 
    return ListTile(
      title: row,
      subtitle: Text(forecastText, style: textStyle),
    );
  }
}