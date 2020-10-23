import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:marine_weather/classes/place.dart';
import 'package:marine_weather/constants.dart';
import 'package:marine_weather/screens/search_screen.dart';
import 'package:marine_weather/screens/selected_place_screen.dart';
import 'package:marine_weather/widgets/place_tile.dart';
import 'package:marine_weather/widgets/top_bar.dart';

class HomeScreen extends StatefulWidget {
  static String screenID = '/homeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Place _myPosition = Place();

  @override
  void initState() {
    super.initState();

    waitForData();
  }

  void waitForData() async {
    Position position = await Place.getMyPosition();
    double lat = position.latitude;
    double long = position.longitude;

    _myPosition = await _myPosition.getDataAboutPosition(lat, long);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopBar(
              leftIcon: Icons.settings,
              leftIconOnTap: () {},
              centerText: 'Wind and Tide',
              rightIcon: Icons.search,
              rightIconOnTap: () {
                Navigator.pushNamed(context, SearchScreen.screenID);
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 10.0),
              child: Column(
                children: [
                  Column(
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
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SelectedPlaceDetailsScreen(
                                        selectedPlace: _myPosition,
                                      ),),);
                        },
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
