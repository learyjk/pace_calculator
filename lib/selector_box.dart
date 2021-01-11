import 'package:flutter/material.dart';
import 'constants.dart';

class SelectorBox extends StatelessWidget {
  SelectorBox(
      {@required this.boxText,
      @required this.onTap,
      this.color = kSelectorBoxInactiveColor});

  final String boxText;
  final Function onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(15),
        alignment: Alignment.center,
        child: Text(boxText),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onTap: onTap,
    );
  }
}
