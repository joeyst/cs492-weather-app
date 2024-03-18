| File Name | Function Header | Summary |
|-----------|----------------|---------|
| user_location.dart | `Future<UserLocation?> getLocationFromAddress(String city, String state, String zip)` | Retrieves a `UserLocation` using the provided city, state, and/or zip code. Returns `null` if no location is found. |
| user_location.dart | `Future<UserLocation> getLocationFromGPS()` | Retrieves a `UserLocation` using the phone's GPS coordinates. |
| user_location.dart | `Future<UserLocation> getLocationFromCoords(double latitude, double longitude)` | Retrieves a `UserLocation` using the provided latitude and longitude coordinates. |
| user_location.dart | `Future<Position> _determinePosition()` | Helper function from the Geolocator package that determines the current position of the device. |
| location_database.dart | `static Future<LocationDatabase> open()` | Opens the location database and creates it if it doesn't exist. |
| location_database.dart | `void close()` | Closes the location database. |
| location_database.dart | `Future<List<UserLocation>> getLocations()` | Retrieves all stored locations from the database. |
| location_database.dart | `void insertLocation(UserLocation location)` | Inserts a new location into the database. |
| location_database.dart | `void deleteLocation(UserLocation location)` | Deletes a location from the database. |
| weather_forecast.dart | `Future<List<WeatherForecast>> getHourlyForecasts(UserLocation location)` | Retrieves hourly weather forecasts for the specified location. |
| weather_forecast.dart | `Future<List<WeatherForecast>> getTwiceDailyForecasts(UserLocation location)` | Retrieves twice-daily weather forecasts for the specified location. |
| weather_forecast.dart | `Future<List<WeatherForecast>> getWeatherForecasts(UserLocation location, bool hourly)` | Retrieves weather forecasts (hourly or twice-daily) for the specified location using the Weather API. |