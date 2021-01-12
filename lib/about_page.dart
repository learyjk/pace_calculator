import 'package:flutter/material.dart';
import 'package:pace_calculator/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants.dart';

class AboutPage extends StatelessWidget {
  final String year = DateTime.now().year.toString();

  _launchURL() async {
    const url = 'https://keeganleary.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About')),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Column(
                children: [
                  Text(
                    'Super Pace Calculator',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      '© $year Keegan Leary',
                      textAlign: TextAlign.center,
                      style: kBylineStyle,
                    ),
                  ),
                ],
              ),
              width: double.infinity,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 0, color: Colors.white, spreadRadius: 3),
                ],
              ),
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage('images/keegan.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: InkWell(
                child: Text(
                  'Check out what I\'m up to.',
                  style: kLinkStyle,
                ),
                onTap: () => _launchURL(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
