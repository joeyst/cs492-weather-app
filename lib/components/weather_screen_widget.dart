import 'package:cs492_weather_app/models/weather_forecast.dart';
import '../models/user_location.dart';
import 'package:flutter/material.dart';
import 'location_widget.dart';

class WeatherScreenWidget extends StatefulWidget {
  final Function getLocation;
  final Function getForecasts;
  final Function getForecastsHourly;
  final Function setLocation;

  const WeatherScreenWidget(
      {super.key,
      required this.getLocation,
      required this.getForecasts,
      required this.getForecastsHourly,
      required this.setLocation});

  @override
  State<WeatherScreenWidget> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreenWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.getLocation() != null && widget.getForecasts().isNotEmpty) {
      return ForecastWidget(
            context: context,
            location: widget.getLocation(),
            forecasts: widget.getForecastsHourly());
    } else {
      return LocationWidget(widget: widget);
    }
  }
}

class ForecastWidget extends StatelessWidget {
  final UserLocation location;
  final List<WeatherForecast> forecasts;
  final BuildContext context;

  const ForecastWidget(
      {super.key,
      required this.context,
      required this.location,
      required this.forecasts});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LocationTextWidget(location: location),
        TemperatureWidget(forecasts: forecasts),
        DescriptionWidget(forecasts: forecasts)
      ],
    );
  }
}

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({
    super.key,
    required this.forecasts,
  });

  final List<WeatherForecast> forecasts;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      width: 500,
      child: Center(
          child: Text(forecasts.elementAt(0).shortForecast,
              style: Theme.of(context).textTheme.bodyMedium)),
    );
  }
}

class TemperatureWidget extends StatelessWidget {
  const TemperatureWidget({
    super.key,
    required this.forecasts,
  });

  final List<WeatherForecast> forecasts;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 60,
      child: Center(
        child: Text('${forecasts.elementAt(0).temperature}º',
            style: Theme.of(context).textTheme.displayLarge),
      ),
    );
  }
}

class LocationTextWidget extends StatelessWidget {
  const LocationTextWidget({
    super.key,
    required this.location,
  });

  final UserLocation location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: 500,
        child: Text("${location.city}, ${location.state}, ${location.zip}",
            style: Theme.of(context).textTheme.headlineSmall),
      ),
    );
  }
}
