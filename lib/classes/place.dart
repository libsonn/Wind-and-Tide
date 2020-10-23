import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:marine_weather/constants.dart';
import 'package:marine_weather/config.dart' as config;

class Place {
  //Address
  String _placeDescription = '';
  String _weatherDescription = 'weather description';

  //Google coordinates
  double _latitude = 0.00;
  double _longitude = 0.00;
  double _temperature = 0.00;

  //GPS coordinates
  int _latitudeDeg = 0;
  int _latitudeMin = 0;
  int _latitudeSec = 0;
  int _longitudeDeg = 0;
  int _longitudeMin = 0;
  int _longitudeSec = 0;

  //Hemispheres of latitude and longitude
  String _latHemisphere = '?';
  String _longHemisphere = '?';

  //Constructor
  Place();

  //Functions creating places
  static Future<Position> getMyPosition() async {
    Position position = await getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    return position;
  }

  Future<Place> getDataAboutPosition(double latitude, double longitude) async {
    _placeDescription = await getAddressFromCoordinates(latitude, longitude);
    _temperature = await getTemperatureData(latitude, longitude);
    _weatherDescription = await getWeatherDescriptionData(latitude, longitude);

    convertCoordinates(latitude, longitude);
    getHemispheres(latitude, longitude);

    return this;
  }

  Future<Place> getDetailsFromAddressDescription(String address) async {
    double latitude = await getLatitudeFromAddress(address);
    double longitude = await getLongitudeFromAddress(address);

    if (_latitude != 400) {
      return await getDataAboutPosition(latitude, longitude);
    }

    return this;
  }

  //Async functions getting data from APIs
  Future<double> getTemperatureData(double latitude, double longitude) async {
    double _temperature = 0;

    var response = await http.get(
      openWeatherUrl +
          "lat=$latitude&lon=$longitude&exclude=current&units=metric&appid=${config.openWeatherApiKey}",
    );

    if (response.statusCode == 200) {
      var data = response.body;
      var decodedData = json.decode(data);

      _temperature = decodedData['hourly'][0]['temp'];
    }

    return _temperature.toDouble();
  }

  Future<String> getWeatherDescriptionData(
      double latitude, double longitude) async {
    String _weatherDescription = '';

    var response = await http.get(
      openWeatherUrl +
          "lat=$latitude&lon=$longitude&exclude=current&appid=${config.openWeatherApiKey}",
    );

    if (response.statusCode == 200) {
      var data = response.body;
      var decodedData = json.decode(data);
      _weatherDescription =
          decodedData['hourly'][0]['weather'][0]['description'];
    }

    return _weatherDescription.toString();
  }

  Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    List placemark = await placemarkFromCoordinates(latitude, longitude);
    return placemark[0].name;
  }

  Future<double> getLatitudeFromAddress(String address) async {
    List location = [];
    try {
      location = await locationFromAddress(address);
    } catch (e) {
      location.add(Location(longitude: 400, latitude: 400));
      _weatherDescription = 'COULDN\'T FIND COORDINATES';
      _latitude = 0;
    }

    return location[0].latitude;
  }

  Future<double> getLongitudeFromAddress(String address) async {
    List location = [];

    try {
      location = await locationFromAddress(address);
    } catch (e) {
      location.add(Location(longitude: 400, latitude: 400));
      _weatherDescription = 'COULDN\'T FIND COORDINATES';
      _longitude = 0;
    }
    return location[0].longitude;
  }

  //Functions calculating coordinates

  void convertCoordinates(double latitude, double longitude) {
    _latitudeDeg = latitude.truncate();
    _latitudeMin = ((latitude - _latitudeDeg).abs() * 60).truncate();
    _latitudeSec =
        ((3600 * (latitude - _latitudeDeg).abs()) - 60 * _latitudeMin)
            .truncate();
    _longitudeDeg = longitude.truncate();
    _longitudeMin = ((longitude - _longitudeDeg).abs() * 60).truncate();
    _longitudeSec =
        ((3600 * (longitude - _longitudeDeg).abs()) - 60 * _longitudeMin)
            .truncate();
  }

  void getHemispheres(double latitude, double longitude) {
    if (latitude > 0) {
      _latHemisphere = 'North';
    } else {
      _latHemisphere = 'South';
    }

    if (longitude > 0) {
      _longHemisphere = 'East';
    } else {
      _longHemisphere = 'West';
    }
  }

  static double calculateLatitudeFromGeo(int latDeg, int latMin, int latSec) {
    double latitude = 0.0;
    latitude = latDeg + (latMin / 60) + (latSec / 3600);

    return latitude;
  }

  static double calculateLongitudeFromGeo(
      int longDeg, int longMin, int longSec) {
    double longitude = 0.0;
    longitude = longDeg + (longMin / 60) + (longSec / 3600);

    return longitude;
  }

  //Setters for Google coordinates system
  void setLatitude(double latitude) {
    _latitude = latitude;
  }

  void setLongitude(double longitude) {
    _longitude = longitude;
  }

  void setTemperature(double temperature) {
    _temperature = temperature;
  }

  //Setters for GPS coordinates system
  void setLatitudeDeg(int latitudeDeg) {
    _latitudeDeg = latitudeDeg;
  }

  void setLatitudeMin(int latitudeMin) {
    _latitudeMin = latitudeMin;
  }

  void setLatitudeSec(int latitudeSec) {
    _latitudeSec = latitudeSec;
  }

  void setLongitudeDeg(int longitudeDeg) {
    _longitudeDeg = longitudeDeg;
  }

  void setLongitudeMin(int longitudeMin) {
    _longitudeMin = longitudeMin;
  }

  void setLongitudeSec(int longitudeSec) {
    _longitudeSec = longitudeSec;
  }

  void setPlaceDescription(String description) {
    _placeDescription = description;
  }

  void setWeatherDescription(String description) {
    _weatherDescription = description;
  }

  //Setters of hemispheres
  void setLatHepisphere(String latHemisphere) {
    _latHemisphere = latHemisphere;
  }

  void setLongHepisphere(String longHemisphere) {
    _longHemisphere = longHemisphere;
  }

  //Getters
  String getDescription() => _placeDescription;
  String getWeatherDescription() => _weatherDescription;

  double getLatitude() => _latitude;
  double getLongitude() => _longitude;
  double getTemperature() => _temperature;

  int getLatitudeDeg() => _latitudeDeg;
  int getLatitudeMin() => _latitudeMin;
  int getLatitudeSec() => _latitudeSec;

  int getLongitudeDeg() => _longitudeDeg;
  int getLongitudeMin() => _longitudeMin;
  int getLongitudeSec() => _longitudeSec;

  String getLatHemisphere() => _latHemisphere;
  String getLongHemisphere() => _longHemisphere;
}
