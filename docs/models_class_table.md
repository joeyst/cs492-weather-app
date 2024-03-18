| Class Name | Purpose |
|------------|---------|
| `UserLocation` | Represents a user's location with latitude, longitude, city, state, and zip code. Provides methods to retrieve location information from an address, GPS coordinates, or latitude/longitude. |
| `LocationDatabase` | Manages the storage and retrieval of user locations in a SQLite database. Provides methods to open and close the database, as well as insert, delete, and retrieve location entries. |
| `WeatherForecast` | Represents a weather forecast with various properties such as temperature, wind speed, and forecast descriptions. Provides methods to retrieve hourly and twice-daily forecasts for a given user location using the Weather API. |
| `Position` | Represents a geographical position, typically obtained from the device's GPS or network location providers. It contains properties such as latitude, longitude, altitude, accuracy, and timestamp. |
