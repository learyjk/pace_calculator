import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pace_calculator/constants.dart';
import 'bottom_button.dart';
import 'calculator_alert.dart';
import 'selector_box.dart';
import 'about_page.dart';

enum Units { miles, km }

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  List<bool> isSelected = [true, false];
  final formKey = GlobalKey<FormState>();

  //FormTextField variables. Strings so they can be saved, convert to int later.
  String distance;
  String totalTimeHours;
  String totalTimeMinutes;
  String totalTimeSeconds;
  String paceHours;
  String paceMinutes;
  String paceSeconds;

  //Times processed to seconds
  double iDistance;
  int iTotalTimeInSeconds;
  int iTotalPaceInSeconds;

  Units selectedUnits = Units.miles;

  int convertToSeconds(String hours, String minutes, String seconds) {
    if (hours == '') hours = '0';
    if (minutes == '') minutes = '0';
    if (seconds == '') seconds = '0';
    return int.parse(hours) * 3600 +
        int.parse(minutes) * 60 +
        int.parse(seconds);
  }

  void calculate() {
    formKey.currentState.save();

    bool hasDistance = false;
    bool hasTotalTime = false;
    bool hasPace = false;

    //some sort of distance is entered
    if (distance != '') {
      hasDistance = true;
      iDistance = double.parse(distance);
    }
    // some sort of total time is entered.
    if (totalTimeHours != '' ||
        totalTimeMinutes != '' ||
        totalTimeSeconds != '') {
      iTotalTimeInSeconds =
          convertToSeconds(totalTimeHours, totalTimeMinutes, totalTimeSeconds);
      hasTotalTime = true;
    }

    // print('paceHours: $paceHours');
    // print('paceMinutes: $paceMinutes');
    // print('paceSeconds: $paceSeconds');
    // some sort of pace is entered.
    if (paceHours != '' || paceMinutes != '' || paceSeconds != '') {
      iTotalPaceInSeconds =
          convertToSeconds(paceHours, paceMinutes, paceSeconds);
      hasPace = true;
    }

    // print('hasDistance: $hasDistance');
    // print('hasTotalTime: $hasTotalTime');
    // print('hasPace: $hasPace');
    int variableCount = 0;
    if (hasDistance) variableCount++;
    if (hasTotalTime) variableCount++;
    if (hasPace) variableCount++;

    //user did not enter proper number of fields.
    if (variableCount != 2) {
      //print('Please enter 2 of 3 sections.');
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CalculatorAlert(
              title: 'WHOOPS!',
              content: 'Enter data in ANY TWO of: Distance, Total Time, Pace',
              secondaryText: 'please try again...',
            );
          });
    }

    //Calculate the required pace.
    else if (hasDistance && hasTotalTime) {
      //print('user entered distance and total time.');

      int pace = (iTotalTimeInSeconds / iDistance).toInt();
      String paceFormatted =
          Duration(seconds: pace).toString().split('.').first.padLeft(8, '0');

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CalculatorAlert(
              title: 'PACE',
              content: paceFormatted,
              secondaryText:
                  selectedUnits == Units.miles ? 'per mile' : 'per km',
            );
          });
    } else if (hasDistance && hasPace) {
      // print('user entered distance and pace. Get Total time');
      int totalTime = (iDistance * iTotalPaceInSeconds).toInt();
      String totalTimeFormatted = Duration(seconds: totalTime)
          .toString()
          .split('.')
          .first
          .padLeft(8, '0');

      String units = selectedUnits == Units.miles ? 'miles' : 'km';

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CalculatorAlert(
              title: 'TOTAL TIME',
              content: totalTimeFormatted,
              secondaryText: 'to run $distance $units',
            );
          });
    } else if (hasTotalTime && hasPace) {
      //print('user entered total time and pace. Get distance');
      double distanceTraveled = (iTotalTimeInSeconds / iTotalPaceInSeconds);
      String units = selectedUnits == Units.miles ? 'miles' : 'km';
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CalculatorAlert(
              title: 'DISTANCE',
              content: distanceTraveled.toStringAsFixed(1),
              secondaryText: '$units traveled',
            );
          });
    } else {
      print('error with field values.');
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CalculatorAlert(
              title: 'WHOOPS...',
              content: 'We had a problem with the values you entered.',
              secondaryText: 'Sorry... please try again!',
            );
          });
    }
  }

  void resetFields() {
    formKey.currentState.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Pace Calculator'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            'Distance',
                            style: kHeaderTextStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SelectorBox(
                          boxText: 'Miles',
                          onTap: () {
                            setState(() {
                              selectedUnits = Units.miles;
                            });
                          },
                          color: selectedUnits == Units.miles
                              ? kAccentColor
                              : kSelectorBoxInactiveColor,
                        ),
                      ),
                      Expanded(
                        child: SelectorBox(
                          boxText: 'Kilometers',
                          onTap: () {
                            setState(() {
                              selectedUnits = Units.km;
                            });
                          },
                          color: selectedUnits == Units.km
                              ? kAccentColor
                              : kSelectorBoxInactiveColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Distance",
                                border: OutlineInputBorder(),
                                labelStyle: kHeaderTextStyle),
                            keyboardType: TextInputType.numberWithOptions(
                                signed: false, decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^(\d+)?\.?\d{0,2}'))
                            ],
                            onSaved: (input) => distance = input,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            'Total Time',
                            style: kHeaderTextStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Hours",
                                border: OutlineInputBorder(),
                                labelStyle: kHeaderTextStyle),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onSaved: (input) => totalTimeHours = input,
                          ),
                        ),
                      ),
                      Text(
                        ':',
                        style: kHeaderTextStyle,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Minutes",
                                border: OutlineInputBorder(),
                                labelStyle: kHeaderTextStyle),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'\b([0-9]|[0-5]\d|60)\b'))
                            ],
                            onSaved: (input) => totalTimeMinutes = input,
                          ),
                        ),
                      ),
                      Text(
                        ':',
                        style: kHeaderTextStyle,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Seconds",
                                border: OutlineInputBorder(),
                                labelStyle: kHeaderTextStyle),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'\b([0-9]|[0-5]\d|60)\b'))
                            ],
                            onSaved: (input) => totalTimeSeconds = input,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            'Pace',
                            style: kHeaderTextStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Hours",
                                border: OutlineInputBorder(),
                                labelStyle: kHeaderTextStyle),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'\b([0-9]|[0-9]\d|99)\b'))
                            ],
                            onSaved: (input) => paceHours = input,
                          ),
                        ),
                      ),
                      Text(
                        ':',
                        style: kHeaderTextStyle,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Minutes",
                                border: OutlineInputBorder(),
                                labelStyle: kHeaderTextStyle),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'\b([0-9]|[0-5]\d|60)\b'))
                            ],
                            onSaved: (input) => paceMinutes = input,
                          ),
                        ),
                      ),
                      Text(
                        ':',
                        style: kHeaderTextStyle,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: "Seconds",
                                border: OutlineInputBorder(),
                                labelStyle: kHeaderTextStyle),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'\b([0-9]|[0-5]\d|60)\b'))
                            ],
                            onSaved: (input) => paceSeconds = input,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            right: 8.0,
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Text(
                          selectedUnits == Units.miles ? 'per mile' : 'per km',
                          style: kAlertSmallItalicStyle,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: BottomButton(
              onTap: resetFields,
              buttonTitle: 'RESET',
              buttonColor: kBottomButtonColorReset,
            ),
          ),
          Expanded(
            flex: 3,
            child: BottomButton(
              onTap: calculate,
              buttonTitle: 'CALCULATE',
              buttonColor: kAccentColor,
            ),
          ),
        ],
      ),
    );
  }
}
