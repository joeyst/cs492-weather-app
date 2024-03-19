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
        Provider<CurrentLocationProvider>(create: (_) => currentLocationProvider),
        Provider<LocationListProvider>(create: (_) => locationListProvider),
        Provider<ThemeProvider>(create: (_) => themeProvider),
      ],
      child:
        MaterialApp(
          title: 'CS 492 Weather App',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeProvider.themeMode(),
          home: MyHomePage(title: "CS492 Weather App"),
        )
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final currentLocationProvider = context.watch<CurrentLocationProvider>();
    return Scaffold(
      appBar: AppBar(
        title: FlippedTextWidget(title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Toggle hourly.',
            onPressed: () {
              currentLocationProvider.setHourly(false);
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
    final currentLocationProvider = context.watch<CurrentLocationProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    // final currentLocationProvider = Provider.of<CurrentLocationProvider>(context);
    // final themeProvider = Provider.of<ThemeProvider>(context);

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

/*
Widget modeToggle(BuildContext context, ThemeProvider themeProvider) {
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
*/

Widget modeToggle(BuildContext context) {
  // final themeProvider = Provider.of<ThemeProvider>(context);
  final themeProvider = context.watch<ThemeProvider>();
  return
      SizedBox(
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

/*
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
      body: Consumer<CurrentLocationProvider>(
        builder: (context, currentLocationProvider, _) {
          return SafeArea(
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
          );
        },
      ),
    );
  }
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

/*
Widget modeToggle(BuildContext context) {
  return Consumer<ThemeProvider>(
    builder: (context, themeProvider, _) {
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
    },
  );
}
*/

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
*/

/*
appBar: AppBar(
  title: FlippableTextWidget(widget.title),
  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
  actions: [
    IconButton(
      icon: const Icon(Icons.settings),
      tooltip: 'Open Settings',
      onPressed: _openEndDrawer,
    ),
    IconButton(
      icon: const Icon(Icons.refresh),
      tooltip: 'Toggle hourly.',
      onPressed: _toggleHourly,
    ),
  ],
*/

/*
class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<UserLocation> locations = [];
  List<WeatherForecast> _forecasts = [];
  List<WeatherForecast> _forecastsHourly = [];
  UserLocation? _location;

  void setLocation(UserLocation location) async {
    setState(() {
      _location = location;
      _getForecasts();
      _setLocationPref(location);
    });
  }

  void _setLocationPref(UserLocation location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("location", location.toJsonString());
  }

  void _getForecasts() async {
    if (_location != null) {
      // We collect both the twice-daily forecasts and the hourly forecasts
      List<WeatherForecast> forecasts = await getWeatherForecasts(_location!, false);
      List<WeatherForecast> forecastsHourly = await getWeatherForecasts(_location!, true);
      setState(() {
        _forecasts = forecasts;
        _forecastsHourly = forecastsHourly;
      });
    }
  }

  List<WeatherForecast> getForecasts() {
    return _forecasts;
  }

  List<WeatherForecast> getForecastsHourly() {
    return _forecastsHourly;
  }


  UserLocation? getLocation() {
    return _location;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _closeEndDrawer() {
    Navigator.of(context).pop();
  }

  bool _light = true;

  @override
  void initState() {
    super.initState();
    _light = true;

    _initMode();
  }

  void _initMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? light = prefs.getBool("light");
    String? locationString = prefs.getString("location");

    if (light != null) {
      setState(() {
        _light = light;
        _setTheme(_light);
      });
    }

    if (locationString != null) {
      setLocation(UserLocation.fromJson(jsonDecode(locationString)));
    }
  }

  void _toggleLight(value) async {
    setState(() {
      _light = value;
      _setTheme(value);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("light", value);
  }

  void _setTheme(value) {
    return Provider.of<ThemeProvider>(context, listen: false).setLight(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: FlippableTextWidget(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Open Settings',
            onPressed: _openEndDrawer,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Toggle hourly.',
            onPressed: _toggleHourly,
          ),
        ],
      ),
      // body: WeatherScreenWidget(
      //     getLocation: getLocation,
      //     getForecasts: getForecasts,
      //     getForecastsHourly: getForecastsHourly,
      //     setLocation: setLocation),
      body: WeatherScreenListWidget(),
      endDrawer: Drawer(
        child: settingsDrawer(),
      ),
    );
  }

  void _toggleHourly() {
    Provider.of<CurrentLocationProvider>(context, listen: false).setHourly(false);
  }

  SizedBox modeToggle() {
    return SizedBox(
      width: 400,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_light ? "Light Mode" : "Dark Mode",
              style: Theme.of(context).textTheme.labelLarge),
          Transform.scale(
            scale: 0.5,
            child: Switch(
              value: _light,
              onChanged: _toggleLight,
            ),
          ),
        ],
      ),
    );
  }

  SafeArea settingsDrawer() {
    return SafeArea(
      child: Column(
        children: [
          SettingsHeaderText(context: context, text: "Settings:"),
          modeToggle(),
          SettingsHeaderText(context: context, text: "My Locations:"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Location(
                setLocation: setLocation,
                getLocation: getLocation,
                closeEndDrawer: _closeEndDrawer),
          ),
          ElevatedButton(
              onPressed: _closeEndDrawer, child: const Text("Close Settings"))
        ],
      ),
    );
  }
}

class SettingsHeaderText extends StatelessWidget {
  final String text;
  final BuildContext context;
  const SettingsHeaderText(
      {super.key, required this.context, required this.text});

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
*/