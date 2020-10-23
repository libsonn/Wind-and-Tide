import 'package:flutter/material.dart';
import 'package:marine_weather/classes/place.dart';
import 'package:marine_weather/screens/home_screen.dart';
import 'package:marine_weather/widgets/place_tile.dart';
import 'package:marine_weather/widgets/top_bar.dart';
import 'package:marine_weather/constants.dart';

class SelectedPlaceDetailsScreen extends StatefulWidget {
  static String screenID = '/selectedPlaceDetails';

  SelectedPlaceDetailsScreen({@required this.selectedPlace});
  final Place selectedPlace;

  @override
  _SelectedPlaceDetailsScreenState createState() =>
      _SelectedPlaceDetailsScreenState(selectedPlace: selectedPlace);
}

class _SelectedPlaceDetailsScreenState
    extends State<SelectedPlaceDetailsScreen> {
  _SelectedPlaceDetailsScreenState({@required this.selectedPlace});
  Place selectedPlace;

  ScrollController _scrollController;
  int _choosedDate = 0;
  double _itemExtent = 100;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    if (selectedPlace.getLatitude() != 0.0 &&
        selectedPlace.getLongitude() != 0.0) {
      waitForData();
    }
  }

  void waitForData() async {
    selectedPlace = await selectedPlace
        .getDetailsFromAddressDescription(selectedPlace.getDescription());

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopBar(
              leftIcon: Icons.keyboard_backspace,
              leftIconOnTap: () {
                Navigator.pushNamed(context, HomeScreen.screenID);
              },
              centerText: 'Forecast',
              rightIcon: Icons.favorite_border_sharp,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 10.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: ListView.builder(
                      itemCount: 7,
                      itemExtent: _itemExtent,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      itemBuilder: (context, index) => Row(
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _choosedDate = index;
                                    _scrollController.animateTo(
                                        _choosedDate.roundToDouble() * 40,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.linear);
                                  });
                                },
                                child: Text(
                                  DateTime.now()
                                          .add(Duration(days: index))
                                          .day
                                          .toString() +
                                      '.' +
                                      DateTime.now()
                                          .add(Duration(days: index))
                                          .month
                                          .toString(),
                                  style: _choosedDate == index
                                      ? TextStyle(
                                          fontSize: 20, color: kWhiteTextColor)
                                      : TextStyle(
                                          fontSize: 20, color: kGreyTextColor),
                                ),
                              ),
                              SizedBox(
                                height: 3.0,
                              ),
                              _choosedDate == index
                                  ? Container(
                                      width: 40,
                                      height: 3,
                                      decoration: BoxDecoration(
                                          gradient: kBlueGradient),
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  PlaceTile(
                    place: selectedPlace,
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
