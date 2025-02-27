import 'package:geolocator/geolocator.dart';

import 'package:geocoding/geocoding.dart';

import 'dart:convert';

// User location model
// Contains required information for:
// Displaying location to user (city, state, zip)
// Finding Forecast information in Weather API (latitude, Longitude)

const allowedNation = "United States";

class UserLocation {
  double latitude;
  double longitude;
  String city;
  String state;
  String zip;

  UserLocation(
      {required this.latitude,
      required this.longitude,
      required this.city,
      required this.state,
      required this.zip});

  // This overrides the == operator
  // This allows us to define how we want to establish equality between two UserLocation Objects
  // In this case, I want anything that shares city, state, and zip to be considered equal, even if lat/long are not equal
  @override
  bool operator ==(Object other) =>
      other is UserLocation &&
      city == other.city &&
      state == other.state &&
      zip == other.zip;

  // We should alo override the hashCode when we override the == operator
  @override
  int get hashCode => Object.hash(city, state, zip);

  String toJsonString() {
    Map<String, dynamic> mappedObject = {
      "latitude": latitude,
      "longitude": longitude,
      "city": city,
      "state": state,
      "zip": zip
    };

    return jsonEncode(mappedObject);
  }

  factory UserLocation.fromJsonString(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    return UserLocation.fromJson(json);
  }

  factory UserLocation.fromJson(Map<String, dynamic> json) {
    try {
      return switch (json) {
        {
          'latitude': double latitude,
          'longitude': double longitude,
          'city': String city,
          'state': String state,
          'zip': String zip
        } =>
          UserLocation(
              latitude: latitude,
              longitude: longitude,
              city: city,
              state: state,
              zip: zip),
        _ => throw const FormatException('Failed to load UserLocation.'),
      };
    } on Exception {
      return UserLocation.bend();
    }
  }

  String name() {
    return "$city, $state, $zip";
  }

  factory UserLocation.bend() {
    return UserLocation(
      latitude: 44.0582,
      longitude: -121.3153, // Source: https://www.latlong.net/place/bend-or-usa-10063.html#:~:text=The%20latitude%20of%20Bend%2C%20OR,%C2%B0%2018'%2055.1088''%20W.
      city: "Bend",
      state: "Oregon",
      zip: "97702",
    );
  }

  factory UserLocation.prineville() {
    return UserLocation(
      latitude: 44.300,
      longitude: -120.8345,
      city: "Prineville",
      state: "Oregon",
      zip: "97754",
    );
  }
}

Future<UserLocation?> getLocationFromAddress(
    String city, String state, String zip) async {
  // async function that delivers a UserLocation using the city, state, and/or zip

  String addressString = "$city $state $zip";

  // geocoding can potentially return locations with only partial addresses
  try {
    List<Location> locations = await locationFromAddress(addressString);
    return getLocationFromCoords(locations[0].latitude, locations[0].longitude);
  } on Exception {
    return Future.value(UserLocation.prineville());
  }
}

Future<UserLocation> getLocationFromGPS() async {
  // async function that delivers a UserLocation using phone's GPS Coordinates

  Position position = await _determinePosition();

  return getLocationFromCoords(position.latitude, position.longitude);
}

Future<UserLocation> getLocationFromCoords(double latitude, double longitude) async {
    String city = "";
    String state = "";
    String zip = "";
    String country = "";

    List<Placemark> placemarks = [];

    try {
      placemarks = await placemarkFromCoordinates(latitude, longitude);
    } on Exception {
      return UserLocation(
          latitude: 44.0582,
          longitude: -121.3153, // Source: https://www.latlong.net/place/bend-or-usa-10063.html#:~:text=The%20latitude%20of%20Bend%2C%20OR,%C2%B0%2018'%2055.1088''%20W. 
          city: "Bend",
          state: "Oregon",
          zip: "97702");
    }
    // Finding city, state, and zip in the address information
    for (int i = 0; i < placemarks.length; i++) {
      if (city == "") {
        city = placemarks[i].locality!;
      }
      if (state == "") {
        state = placemarks[i].administrativeArea!;
      }
      if (zip == "") {
        zip = placemarks[i].postalCode!;
      }
      if (country == "") {
        country = placemarks[i].country!;
      }
    }

    if (country != allowedNation) {
      Future.error("Error: Location must be in $allowedNation.");
    }

    return UserLocation(
        latitude: latitude,
        longitude: longitude,
        city: city,
        state: state,
        zip: zip);
}

// NOTE: THIS FUNCTION IS A HELPER FUNCTION DIRECTLY FROM THE GEOLOCATOR DOCUMENTATION.
// SEE: https://pub.dev/packages/geolocator

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  try {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  } on Exception catch (e) {
    return Future.value(Position(
        latitude: 44.0582,
        longitude: -121.3153, 
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0));
  }
}
