import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ocean_project/mobileview/constants.dart';

import 'package:ocean_project/mobileview/screen/home_screen.dart';
import 'package:ocean_project/mobileview/screen/mobile_wbinar/mobile_single%20webinar.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class MobileWebinarCard extends StatefulWidget {
  static Map timing;
  @override
  _MobileWebinarCardState createState() => _MobileWebinarCardState();
}

class _MobileWebinarCardState extends State<MobileWebinarCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Upcoming Webinars'),
        leading: BackButton(),
        actions: [
          IconButton(
              icon: Icon(Icons.home),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              })
        ],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('Webinar').snapshots(),
          // ignore: missing_return
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: LinearProgressIndicator(
                  backgroundColor: Colors.blue,
                ),
              );
            } else {
              final messages = snapshot.data.docs;
              List<WebinarCardDb> courseList = [];
              List<int> timingList = [];
              Map<int, Widget> courseMap = {};
              Map<String, Map> timingMap = {};
              for (var message in messages) {
                Timestamp timeStamp = message.data()['timestamp'];
                final courseName = message.data()['course'];
                final trainerName = message.data()['trainer name'];
                final payment = message.data()['payment'];
                final designation = message.data()['designation'];
                final trainerImage = message.data()['trainer image'];
                final mainTitle = message.data()['main subtitle'];
                int duration = int.parse(message.data()['webinar duration']);

                int yearFormat;
                int monthFormat;
                int dayFormat;
                int hourFormat;
                int minuteFormat;
                int secondsFormat;

                var year = DateFormat('y');
                var month = DateFormat('MM');
                var day = DateFormat('d');
                var hour = DateFormat('hh');
                var minute = DateFormat('mm');
                var seconds = DateFormat('s');

                yearFormat = int.parse(year.format(timeStamp.toDate()));
                monthFormat = int.parse(month.format(timeStamp.toDate()));
                dayFormat = int.parse(day.format(timeStamp.toDate()));
                hourFormat = int.parse(hour.format(timeStamp.toDate()));
                minuteFormat = int.parse(minute.format(timeStamp.toDate()));
                secondsFormat = int.parse(seconds.format(timeStamp.toDate()));
                var timeFormat = DateFormat('a').format(timeStamp.toDate());

                var defrenceTime = DateTime(
                        yearFormat,
                        monthFormat,
                        dayFormat,
                        timeFormat == 'AM' ? hourFormat : hourFormat + 12,
                        minuteFormat,
                        secondsFormat)
                    .difference(DateTime.now())
                    .inSeconds;

                var date = DateFormat('d/MM/y').format(timeStamp.toDate());

                var timing = DateFormat.jm().format(timeStamp.toDate());

                //for mail info
                String toTimeFormat = timeFormat;
                int toTime = hourFormat;
                int toDuration = duration;
                if (toDuration >= 60) {
                  var hourcalculate = toDuration ~/ 60;
                  toDuration -= hourcalculate * 60;
                  toTime += hourcalculate;
                  if (toTime == 12) {
                    if (timeFormat == 'AM') {
                      toTimeFormat = 'PM';
                    } else {
                      toTimeFormat = 'AM';
                    }
                  } else if (toTime > 12) {
                    toTime -= 12;
                    if (timeFormat == 'AM') {
                      toTimeFormat = 'PM';
                    } else {
                      toTimeFormat = 'AM';
                    }
                  }
                }

                var monthString = DateFormat('MMMM');
                var monthFormatString = monthString.format(timeStamp.toDate());
                Map dateForMail = {
                  'Year': yearFormat,
                  'Month': monthFormatString,
                  'Day': dayFormat,
                  'Hours': hourFormat,
                  'To Hours': toTime,
                  'Minutes': minuteFormat,
                  'To Minutes': toDuration,
                  'DayFormat': timeFormat,
                  'To DayFormat': toTimeFormat
                };
                timingMap.addAll({courseName: dateForMail});

                final webinar = WebinarCardDb(
                  topic: courseName,
                  payment: payment,
                  mentorDesignation: designation,
                  mentorName: trainerName,
                  mentorImage: trainerImage,
                  date: date.toString(),
                  mainTitle: mainTitle,
                  time: timing.toString(),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MobileSingleWebinarScreen(
                                  topic: courseName,
                                )));
                  },
                );
                if (defrenceTime > 0) {
                  timingList.add(defrenceTime);
                  timingList.sort();
                  courseMap.addAll({defrenceTime: webinar});
                }
              }
              print(timingList);
              for (var i in timingList) {
                courseList.add(courseMap[i]);
              }
              MobileWebinarCard.timing = timingMap;
              return Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: courseList,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class WebinarCardDb extends StatefulWidget {
  WebinarCardDb(
      {this.time,
      this.date,
      this.topic,
      this.mentorDesignation,
      this.mentorName,
      this.mentorImage,
      this.payment,
      this.onPressed,
      this.mainTitle});
  String mentorName;
  Function onPressed;
  String mentorDesignation;
  String time;
  String date;
  String payment;
  String topic;
  String mentorImage;
  String mainTitle;
  @override
  _WebinarCardDbState createState() => _WebinarCardDbState();
}

bool istest = false;

class _WebinarCardDbState extends State<WebinarCardDb> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 350,
      width: 300,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[900].withOpacity(0.3),
                blurRadius: 6,
                spreadRadius: 0,
                offset: Offset(-0, 0))
          ]),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 50,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Date ',
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: kfontname,
                                fontWeight: FontWeight.normal,
                                color: Color(0XFFB2B2B2)),
                          ),
                          Text(
                            widget.date,
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: kfontname,
                                fontWeight: FontWeight.normal,
                                color: Color(0xff15a9ea)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Time ',
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: kfontname,
                                fontWeight: FontWeight.normal,
                                color: Color(0XFFB2B2B2)),
                          ),
                          Text(
                            widget.time,
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: kfontname,
                                fontWeight: FontWeight.normal,
                                color: Color(0xff15a9ea)),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 200,
                  width: 300,
                ),
                Positioned(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    height: 150,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Color(0xff15a9ea),
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.mentorName.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: kfontname,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              widget.mentorDesignation,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  inherit: false,
                                  fontFamily: kfontname,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FlatButton(
                                child: Text(
                                  'Register Now',
                                  style: TextStyle(
                                      color: Color(0xff15A9EA), fontSize: 20),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                color: Colors.white,
                                minWidth: 210,
                                height: 50,
                                onPressed: widget.onPressed,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 20,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(500),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(500),
                        child: Image.network(
                          widget.mentorImage,
                          fit: BoxFit.cover,
                        )),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              alignment: Alignment.center,
              width: 300,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xff15a9ea),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
              ),
              child: Text(
                widget.topic,
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: kfontname,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          Positioned(
            top: 130,
            left: 0,
            child: Container(
              alignment: Alignment.center,
              width: 120,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xff15a9ea),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.payment == 'free'
                      ? SizedBox()
                      : Icon(FontAwesomeIcons.rupeeSign, color: Colors.white),
                  Text(
                    widget.payment.toUpperCase(),
                    style: TextStyle(
                        fontSize: 25,
                        fontFamily: kfontname,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
