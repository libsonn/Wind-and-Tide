import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:marine_weather/classes/place.dart';
import 'package:marine_weather/constants.dart';
import 'package:marine_weather/config.dart' as config;
import 'package:http/http.dart' as http;
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:marine_weather/screens/choosed_place.dart';

class HomeScreen extends StatefulWidget {
  static String screenID = '/homeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static String _enteredAddress = '';
  var _params = "airTemperature";
  Place myPosition = Place(0, 0);

  @override
  void initState() {
    super.initState();
    getPosition();
  }

  void getPosition() async {
    Position position = await getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    String myPositionDescription = await myPosition.getAddressFromCoordinates(
        position.latitude, position.longitude);
    double myPositionTemperature = await myPosition.getDetailedTemperature(
        position.latitude, position.longitude);
    setState(() {
      myPosition.setLatitude(position.latitude);
      myPosition.setLongitude(position.longitude);
      myPosition.setDescription(myPositionDescription);
      myPosition.setTemperature(myPositionTemperature);
      myPosition.getDetails();
    });
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
                              hintText: _enteredAddress.isEmpty
                                  ? 'Name of place to search'
                                  : _enteredAddress,
                              hintStyle: _enteredAddress.isNotEmpty
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
                                  _enteredAddress = prediction.description;
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
                      onPressed: _enteredAddress.isNotEmpty
                          ? () async {
                              Navigator.pushNamed(
                                context,
                                SelectedPlaceDetails.screenID,
                                arguments: _enteredAddress,
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
                      //Potrzebny provider

                      '${myPosition.getDescription()}',
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                        '${myPosition.getLatitudeDeg().abs()}° ${myPosition.getLatitudeMin()}\' ${myPosition.getLatitudeSec()}\'\'${myPosition.getLatHemisphere()[0]}  ${myPosition.getLongitudeDeg().abs()}° ${myPosition.getLongitudeMin()}\' ${myPosition.getLongitudeSec()}\'\'${myPosition.getLongHemisphere()[0]}'),
                    trailing: Column(
                      children: [
                        Expanded(
                          child: Icon(
                            Icons.wb_sunny,
                            color: Colors.yellow,
                            size: 40,
                          ),
                        ),
                        Text('${myPosition.getTemperature()}°C'),
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
