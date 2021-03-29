import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ocean_project/desktopview/constants.dart';

import 'package:ocean_project/mobileview/screen/home_screen.dart';

class MobileJoinSuccessfully extends StatefulWidget {
  MobileJoinSuccessfully({this.joinUserName});
  String joinUserName;
  @override
  _MobileJoinSuccessfullyState createState() => _MobileJoinSuccessfullyState();
}

class _MobileJoinSuccessfullyState extends State<MobileJoinSuccessfully> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.lightBlue[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Expanded(
          //   child: Container(
          //     margin: EdgeInsets.only(left: 30),
          //     child: Image.network(
          //         'https://firebasestorage.googleapis.com/v0/b/ocean-live-project-ea2e7.appspot.com/o/download%20pdf%20svgs%2Fsend%20link%20email.svg?alt=media&token=320bac9a-f711-4037-b999-617915ac062b'),
          //   ),
          // ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 200,
                      color: Colors.white,
                    ),
                    Text(
                      'SUCCESS!',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          inherit: false,
                          color: Colors.white),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      width: 500,
                      child: Text(
                        'Hi ${widget.joinUserName} you have successfully Join our webinar We\'re Sending you join link in your Email',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            inherit: false,
                            fontFamily: kfontname,
                            fontWeight: FontWeight.w100),
                      ),
                    ),
                  ],
                ),
                FlatButton(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      'Continue',
                      style:
                          TextStyle(color: Colors.lightBlue[900], fontSize: 25),
                    ),
                  ),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  },
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
