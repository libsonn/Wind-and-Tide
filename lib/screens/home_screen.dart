import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:marine_weather/classes/place.dart';
import 'package:marine_weather/constants.dart';
import 'package:marine_weather/screens/search_screen.dart';
import 'package:marine_weather/widgets/place_tile.dart';

class HomeScreen extends StatefulWidget {
  static String screenID = '/homeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Place _myPosition = Place(latitude: 0, longitude: 0);

  @override
  void initState() {
    super.initState();
    getPosition();
  }

  void getPosition() async {
    Position position = await getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    String myPositionDescription = await _myPosition.getAddressFromCoordinates(
        position.latitude, position.longitude);
    double myPositionTemperature = await _myPosition.getDetailedTemperature(
        position.latitude, position.longitude);
    setState(() {
      _myPosition.setLatitude(position.latitude);
      _myPosition.setLongitude(position.longitude);
      _myPosition.setDescription(myPositionDescription);
      _myPosition.setTemperature(myPositionTemperature);
      _myPosition.getDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.settings,
                      color: kWhiteTextColor,
                      size: 30.0,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.cloud,
                          color: kWhiteTextColor,
                          size: 20.0,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'Wind and Tide',
                          style:
                              TextStyle(color: kWhiteTextColor, fontSize: 20.0),
                        ),
                      ],
                    ),
                    GestureDetector(
                      child: Icon(
                        Icons.search,
                        color: kWhiteTextColor,
                        size: 30.0,
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, SearchScreen.screenID);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 10.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.gps_fixed,
                              color: kWhiteTextColor,
                              size: 20.0,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              'My localization:',
                              style: TextStyle(
                                  color: kWhiteTextColor, fontSize: 22.0),
                            ),
                          ],
                        ),
                        PlaceTile(
                          place: _myPosition,
                          onTap: () {},
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: kWhiteTextColor,
                              size: 20.0,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              'Favourite places:',
                              style: TextStyle(
                                  color: kWhiteTextColor, fontSize: 22.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
