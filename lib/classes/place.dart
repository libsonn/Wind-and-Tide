import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:marine_weather/constants.dart';
import 'package:marine_weather/config.dart' as config;

class Place {
  //Address
  String _description = '';

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
  Place(this._latitude, this._longitude);

  //Functions
  void getDetails() {
    convertCoordinates();
    getHemispheres();
  }

  void convertCoordinates() {
    _latitudeDeg = _latitude.truncate();
    _latitudeMin = ((_latitude - _latitudeDeg).abs() * 60).truncate();
    _latitudeSec =
        ((3600 * (_latitude - _latitudeDeg).abs()) - 60 * _latitudeMin)
            .truncate();
    _longitudeDeg = _longitude.truncate();
    _longitudeMin = ((_longitude - _longitudeDeg).abs() * 60).truncate();
    _longitudeSec =
        ((3600 * (_longitude - _longitudeDeg).abs()) - 60 * _longitudeMin)
            .truncate();
  }

  void getHemispheres() {
    if (_latitude > 0) {
      _latHemisphere = 'North';
    } else {
      _latHemisphere = 'South';
    }

    if (_longitude > 0) {
      _longHemisphere = 'East';
    } else {
      _longHemisphere = 'West';
    }
  }

  Future<double> getDetailedTemperature(
      double latitude, double longitude) async {
    double _temperature = 0.00;
    var start = new DateTime.now().toUtc();
    start.add(Duration(hours: -1));
    var end = new DateTime.now().toUtc();

    var response = await http.get(
      url +
          "?lat=$latitude&lng=$longitude&params=airTemperature&start=$end&end=$end&key=${config.apiKey}",
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      _temperature = data["hours"][0]["airTemperature"]["sg"] as double;
    }

    return _temperature;
  }

  Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    List placemark = await placemarkFromCoordinates(latitude, longitude);
    return placemark[0].name;
  }

  Future<double> getLatitudeFromAddress(String address) async {
    List location = await locationFromAddress(address);
    return location[0].latitude;
  }

  Future<double> getLongitudeFromAddress(String address) async {
    List location = await locationFromAddress(address);
    return location[0].longitude;
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

  void setDescription(String description) {
    _description = description;
  }

  //Setters of hemispheres
  void setLatHepisphere(String latHemisphere) {
    _latHemisphere = latHemisphere;
  }

  void setLongHepisphere(String longHemisphere) {
    _longHemisphere = longHemisphere;
  }

  //Getters
  String getDescription() => _description;
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
