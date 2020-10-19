import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:marine_weather/classes/place.dart';
import 'package:marine_weather/screens/selected_place_screen.dart';
import '../constants.dart';
import 'package:marine_weather/config.dart' as config;

class SearchScreen extends StatefulWidget {
  static String screenID = '/searchScreen';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _enteredAddress = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Search by name:',
                style: TextStyle(color: kWhiteTextColor, fontSize: 20.0),
              ),
              SizedBox(
                height: 2.0,
              ),
              Card(
                shadowColor: kGreyTextColor,
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
                    disabledColor: kGreyTextColor,
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
                            Place place = Place(latitude: 0, longitude: 0);
                            place.setDescription(_enteredAddress);

                            Navigator.pushNamed(
                              context,
                              SelectedPlaceDetailsScreen.screenID,
                              arguments: place,
                            );
                          }
                        : null,
                    child: Text('Search'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
