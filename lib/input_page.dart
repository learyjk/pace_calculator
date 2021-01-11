import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pace_calculator/constants.dart';
import 'bottom_button.dart';
import 'calculator_alert.dart';
import 'selector_box.dart';

enum Units { miles, km }

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  List<bool> isSelected = [true, false];
  final formKey = GlobalKey<FormState>();

  //FormTextField variables. Strings so they can be saved, convert to int later.
  String _distance;
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
    print('Pressed CALCULATE');
    formKey.currentState.save();
    print('field values saved!');

    bool hasDistance = false;
    bool hasTotalTime = false;
    bool hasPace = false;

    //some sort of distance is entered
    if (_distance != '') {
      hasDistance = true;
      iDistance = double.parse(_distance);
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
          convertToSeconds(totalTimeHours, totalTimeMinutes, totalTimeSeconds);
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
      print('Please enter 2 of 3 sections.');
    }

    //Calculate the required pace.
    if (hasDistance && hasTotalTime) {
      print('user entered distance and total time.');

      int pace = (iTotalTimeInSeconds / iDistance).toInt();
      print('Pace: $pace');
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
      print('user entered distance and pace.');
    } else if (hasTotalTime && hasPace) {
      print('user entered total time and pace');
    } else {
      print('error with field values.');
    }
  }

  void resetFields() {
    formKey.currentState.reset();
    print('Pressed RESET');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pace Calculator'),
      ),
      body: Form(
        key: formKey,
        child: Container(
          margin: EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Distance',
                      style: kHeaderTextStyle,
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
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^(\d+)?\.?\d{0,2}'))
                              ],
                              onSaved: (input) => _distance = input,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Total Time',
                      style: kHeaderTextStyle,
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
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onSaved: (input) => totalTimeSeconds = input,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Pace',
                      style: kHeaderTextStyle,
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
                                FilteringTextInputFormatter.digitsOnly
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
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onSaved: (input) => paceSeconds = input,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
