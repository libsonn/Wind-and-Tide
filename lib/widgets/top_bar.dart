import 'package:flutter/material.dart';

import '../constants.dart';

class TopBar extends StatelessWidget {
  TopBar(
      {this.leftIcon,
      this.centerText,
      this.rightIcon,
      this.leftIconOnTap,
      this.rightIconOnTap});

  final IconData leftIcon;
  final String centerText;
  final IconData rightIcon;
  final Function leftIconOnTap;
  final Function rightIconOnTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: leftIconOnTap,
                          child: Icon(
                leftIcon,
                color: kWhiteTextColor,
                size: 30.0,
              ),
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
                centerText!= null ? Text(
                  centerText,
                  style: TextStyle(color: kWhiteTextColor, fontSize: 20.0),
                ):Text(''),
              ],
            ),
            GestureDetector(
                child: Icon(
                  rightIcon,
                  color: kWhiteTextColor,
                  size: 30.0,
                ),
                onTap: rightIconOnTap),
          ],
        ),
      ),
    );
  }
}
