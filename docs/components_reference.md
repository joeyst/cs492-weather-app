| Class Name | Type | Purpose |
|------------|------|---------|
| `Location` | `Stateful` | Allows users to add and manage locations. Provides options to add location manually (using city, state, and zip) or via GPS. Displays a list of saved locations and allows editing and deleting them. Interacts with the `LocationDatabase` to store and retrieve locations. |
| `WeatherScreen` | `Stateful` | Displays either the `ForecastWidget` or `LocationWidget` based on whether a location is available and forecasts are retrieved. Receives functions to get the current location, forecasts, and set the location. |
| `ForecastWidget` | `Stateless` | Displays the weather forecast information for a given location. Includes the `LocationTextWidget`, `TemperatureWidget`, and `DescriptionWidget`. |
| `DescriptionWidget` | `Stateless` | Displays the short forecast description from the first element of the forecasts list. |
| `TemperatureWidget` | `Stateless` | Displays the temperature from the first element of the forecasts list. |
| `LocationTextWidget` | `Stateless` | Displays the city, state, and zip code of the current location. |
| `LocationWidget` | `Stateless` | Displayed when no location is available. Shows a message indicating that a location is required to begin. Includes the `Location` widget to allow users to add a location. |