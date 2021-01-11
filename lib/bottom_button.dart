import 'package:flutter/material.dart';
import 'package:pace_calculator/constants.dart';

class BottomButton extends StatelessWidget {
  BottomButton(
      {@required this.onTap, @required this.buttonTitle, this.buttonColor});

  final Function onTap;
  final String buttonTitle;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Center(
          child: Text(
            buttonTitle,
            style: kBottomButtonTextStyle,
          ),
        ),
        color: buttonColor,
        padding: EdgeInsets.only(bottom: 20.0),
        margin: EdgeInsets.only(top: 10.0),
        height: kBottomButtonHeight,
      ),
    );
  }
}
