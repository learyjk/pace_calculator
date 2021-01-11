import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pace_calculator/constants.dart';
import 'bottom_button.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  List<bool> isSelected = [true, false];
  final formKey = GlobalKey<FormState>();
  int _distance;

  void _calculate() {
    formKey.currentState.save();
    print('Form saved.  distance is $_distance');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pace Calculator'),
      ),
      body: Form(
        key: formKey,
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
                        child: GestureDetector(
                          child: Card(
                            margin:
                                EdgeInsets.only(left: 10, top: 10, bottom: 10),
                            color: kBottomButtonColorYellow,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text('Miles'),
                              margin: EdgeInsets.all(15.0),
                            ),
                          ),
                          onTap: () {
                            print('tapped miles card.');
                          },
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          child: Card(
                            margin:
                                EdgeInsets.only(right: 10, top: 10, bottom: 10),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text('Kilometers'),
                              margin: EdgeInsets.all(15),
                            ),
                          ),
                          onTap: () {
                            print('tapped kilometers card.');
                          },
                        ),
                      )
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
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onSaved: (input) => _distance = int.parse(input),
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
                    onTap: null,
                    buttonTitle: 'RESET',
                    buttonColor: kBottomButtonColorReset,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: BottomButton(
                    onTap: _calculate,
                    buttonTitle: 'CALCULATE',
                    buttonColor: kBottomButtonColorYellow,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
