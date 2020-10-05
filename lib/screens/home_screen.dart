import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:marine_weather/constants.dart';
import 'package:marine_weather/config.dart' as config;
import 'package:http/http.dart' as http;
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double latitude = 0.00;
  double longitude = 0.00;
  int latitudeDeg = 0;
  int latitudeMin = 0;
  int latitudeSec = 0;
  int longitudeDeg = 0;
  int longitudeMin = 0;
  int longitudeSec = 0;

  String latHemisphere = '?';
  String longHemisphere = '?';

  String addressDescription = 'No data';
  String enteredAddress = '';
  var params = "airTemperature";

  @override
  void initState() {
    super.initState();
    getPosition();
  }

  void getPosition() async {
    Position position = await getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
    getAddressFromCoordinates(latitude, longitude);
    convertCoordinates(latitude, longitude);
    getHemispheres();
  }

  void convertCoordinates(double latitude, double longitude) {
    latitudeDeg = latitude.truncate();
    latitudeMin = ((latitude - latitudeDeg).abs() * 60).truncate();
    latitudeSec =
        ((3600 * (latitude - latitudeDeg).abs()) - 60 * latitudeMin).truncate();
    longitudeDeg = longitude.truncate();
    longitudeMin = ((longitude - longitudeDeg).abs() * 60).truncate();
    longitudeSec =
        ((3600 * (longitude - longitudeDeg).abs()) - 60 * longitudeMin)
            .truncate();
  }

  void getHemispheres() {
    if (latitude > 0) {
      latHemisphere = 'North';
    } else {
      latHemisphere = 'South';
    }

    if (longitude > 0) {
      longHemisphere = 'East';
    } else {
      longHemisphere = 'West';
    }
  }

  void getAddressFromCoordinates(double latitude, double longitude) async {
    List placemark = await placemarkFromCoordinates(latitude, longitude);
    setState(() {
      addressDescription = placemark[0].name;
    });
  }

  Future<double> getLatitudeFromAddress(String address) async {
    double latitude;

    List location = await locationFromAddress(address);
    latitude = location[0].latitude;

    return latitude;
  }

  Future<double> getLongitudeFromAddress(String address) async {
    double longitude;

    List location = await locationFromAddress(address);
    latitude = location[0].longitude;

    return longitude;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 90.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [kBrighterBlueColor, kBackgroundColor],
              ),
            ),
            child: Center(
              child: Text(
                'Wind and Tide',
                style: TextStyle(fontSize: 30.0, color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Places:',
                  style: TextStyle(color: kTextColor, fontSize: 30.0),
                ),
                SizedBox(
                  height: 2.0,
                ),
                Card(
                  shadowColor: kGreyColor,
                  elevation: 10.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: kBackgroundColor,
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.text,
                            cursorColor: kBackgroundColor,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: kBackgroundColor),
                              ),
                              hintText: enteredAddress.isEmpty
                                  ? 'Name of place to search'
                                  : enteredAddress,
                              hintStyle: enteredAddress.isNotEmpty
                                  ? TextStyle(color: kBackgroundColor)
                                  : TextStyle(),
                            ),
                            onTap: () async {
                              Prediction prediction =
                                  await PlacesAutocomplete.show(
                                context: context,
                                apiKey: config.googleApiKey,
                                language: 'en',
                                mode: Mode.overlay,
                              );

                              if (prediction != null) {
                                setState(() {
                                  enteredAddress = prediction.description;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: RaisedButton(
                      disabledColor: kGreyColor,
                      highlightColor: kBrightBlueColor,
                      splashColor: kBrightBlueColor,
                      elevation: 10.0,
                      color: Colors.white,
                      textColor: kBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      onPressed: enteredAddress.isNotEmpty
                          ? () async {
                              //TODO Open next screen with searching results

                              var response = await http.get(
                                url +
                                    "?lat=$latitude&lng=$longitude&params=$params&key=${config.apiKey}",
                              );
                            }
                          : null,
                      child: Text('Search'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.0,
                ),
                Text(
                  'My localization:',
                  style: TextStyle(color: kTextColor, fontSize: 30.0),
                ),
                GestureDetector(
                  child: ListTile(
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    leading: Icon(
                      Icons.location_on,
                      color: kBackgroundColor,
                      size: 40,
                    ),
                    title: Text(
                      '$addressDescription',
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                        '${latitudeDeg.abs()}° $latitudeMin\' $latitudeSec\'\'${latHemisphere[0]}  ${longitudeDeg.abs()}° $longitudeMin\' $longitudeSec\'\'${longHemisphere[0]}'),
                    trailing: Column(
                      children: [
                        Expanded(
                          child: Icon(
                            Icons.wb_sunny,
                            color: Colors.yellow,
                            size: 40,
                          ),
                        ),
                        Text('25°C'),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.0,
                ),
                Text(
                  'Favourites:',
                  style: TextStyle(color: kTextColor, fontSize: 30.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
