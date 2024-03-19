import 'dart:convert';

import 'components/location_widget.dart';
import 'package:flutter/material.dart';
import 'models/user_location.dart';
import 'components/weather_screen_widget.dart';
import 'models/weather_forecast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import './components/flippable_text_widget.dart';

import 'package:provider/provider.dart';

import './models/providers/current_location_provider.dart';
import './models/providers/location_list_provider.dart';
import './models/providers/theme_provider.dart';
import './components/weather_screen_list_widget.dart';
import './components/flipped_text_widget.dart';

const sqlCreateDatabase = 'assets/sql/create.sql';

void main() async {
  databaseFactory = databaseFactoryFfi;
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  LocationListProvider locationListProvider = await LocationListProvider.create();
  CurrentLocationProvider currentLocationProvider = await CurrentLocationProvider.create();
  ThemeProvider themeProvider = await ThemeProvider.create();
  runApp(MyApp(locationListProvider, currentLocationProvider, themeProvider));
}

class MyApp extends StatelessWidget {
  final LocationListProvider locationListProvider;
  final CurrentLocationProvider currentLocationProvider;
  final ThemeProvider themeProvider;
  const MyApp(this.locationListProvider, this.currentLocationProvider, this.themeProvider, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CurrentLocationProvider>(create: (_) => currentLocationProvider),
        ChangeNotifierProvider<LocationListProvider>(create: (_) => locationListProvider),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => themeProvider),
      ],
      child:
      Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'CS 492 Weather App',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeProvider.themeMode(),
          home: MyHomePage(title: "CS492 Weather App"),
        );
          }
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final currentLocationProvider = Provider.of<CurrentLocationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: FlippedTextWidget(title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Switch(
            value: currentLocationProvider.isHourly(),
            onChanged: (value) {
              currentLocationProvider.setHourly(value);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Open Settings',
            onPressed: () => _openEndDrawer(context),
          ),
        ],
      ),
      body: const WeatherScreenListWidget(),
    );
  }

  void _openEndDrawer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsDrawer()),
    );
  }
}

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentLocationProvider = Provider.of<CurrentLocationProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SettingsHeaderText(context: context, text: "Settings:"),
            modeToggle(context),
            SettingsHeaderText(context: context, text: "My Locations:"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Location(
                setLocation: currentLocationProvider.setCurrentLocation,
                getLocation: currentLocationProvider.getCurrentLocation,
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close Settings"),
            ),
          ],
        ),
      ),
    );
  }
}

Widget modeToggle(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context);
  return SizedBox(
    width: 400,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          themeProvider.isLight() ? "Light Mode" : "Dark Mode",
          style: Theme.of(context).textTheme.labelLarge,
        ),
        Transform.scale(
          scale: 0.5,
          child: Switch(
            value: themeProvider.isLight(),
            onChanged: (value) => themeProvider.setLight(value),
          ),
        ),
      ],
    ),
  );
}

class SettingsHeaderText extends StatelessWidget {
  final String text;
  final BuildContext context;

  const SettingsHeaderText({
    super.key,
    required this.context,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
