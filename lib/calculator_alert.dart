import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pace_calculator/constants.dart';

class CalculatorAlert extends StatelessWidget {
  CalculatorAlert(
      {@required this.title, @required this.content, this.secondaryText = ''});

  final String title;
  final String content;
  final String secondaryText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: kHeaderTextStyle,
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            content,
            style: kAlertTitleStyle,
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                secondaryText,
                style: kAlertSmallItalicStyle,
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
