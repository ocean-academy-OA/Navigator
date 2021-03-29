import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ocean_project/desktopview/constants.dart';
import 'package:ocean_project/desktopview/screen/menubar.dart';
import 'package:ocean_project/desktopview/route/routing.dart';
import 'package:ocean_project/webinar/wbinar_menubar.dart';
import 'package:ocean_project/webinar/single_wbinar.dart';
import 'package:ocean_project/webinar/webinar_live.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';

import 'mobile_wbinar/webinar_list.dart';

final _firestore = FirebaseFirestore.instance;

class MobileFlashNotification extends StatefulWidget {
  MobileFlashNotification(
      {this.joinButton,
      this.dismissNotification,
      this.joinButtonName,
      this.webinar,
      this.upcomingButton});
  Function upcomingButton;
  Function joinButton;
  Function dismissNotification;
  String joinButtonName = 'JOIN';
  Map webinar;

  @override
  _MobileFlashNotificationState createState() =>
      _MobileFlashNotificationState();
}

class _MobileFlashNotificationState extends State<MobileFlashNotification> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('@@@@@@@@@@@@@@@@@@@@@@@@');
    print(widget.webinar);

    return Container(
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(),
          Row(
            children: [
              // StreamBuilder<QuerySnapshot>(
              //   stream: _firestore.collection('Webinar').snapshots(),
              //   // ignore: missing_return
              //   builder: (context, snapshot) {
              //     if (!snapshot.hasData) {
              //       return Text("Loading...");
              //     } else {
              //       final messages = snapshot.data.docs;
              //
              //       List<FlashDb> courseList = [];
              //       List<int> timingList = [];
              //       Map<int, Widget> courseMap = {};
              //       List<Widget> currentWebinar = [];
              //
              //       for (var message in messages) {
              //         Timestamp time = message.data()['timestamp'];
              //         final freeWebinarContent = message.data()['course'];
              //         final payment = message.data()['payment'];
              //
              //         int yearFormat;
              //         int monthFormat;
              //         int dayFormat;
              //         int hourFormat;
              //         int minuteFormat;
              //         int secondsFormat;
              //
              //         var year = DateFormat('y');
              //         var month = DateFormat('MM');
              //         var day = DateFormat('d');
              //         var hour = DateFormat('hh');
              //         var minute = DateFormat('mm');
              //         var seconds = DateFormat('s');
              //
              //         yearFormat = int.parse(year.format(time.toDate()));
              //         monthFormat = int.parse(month.format(time.toDate()));
              //         dayFormat = int.parse(day.format(time.toDate()));
              //         hourFormat = int.parse(hour.format(time.toDate()));
              //         minuteFormat = int.parse(minute.format(time.toDate()));
              //         secondsFormat = int.parse(seconds.format(time.toDate()));
              //         var timeFormat = DateFormat('a').format(time.toDate());
              //
              //         var defrenceTime = DateTime(
              //             yearFormat,
              //             monthFormat,
              //             dayFormat,
              //             timeFormat == 'AM' ? hourFormat : hourFormat + 12,
              //             minuteFormat,
              //             secondsFormat)
              //             .difference(DateTime.now())
              //             .inSeconds;
              //
              //         if (defrenceTime > 0) {
              //           final webinar = FlashDb(
              //             content: freeWebinarContent,
              //             joinButton: widget.joinButton,
              //             dismissNotification: widget.dismissNotification,
              //             payment: payment,
              //             wbinarLive: currentWebinar,
              //           );
              //           timingList.add(defrenceTime);
              //           timingList.sort();
              //
              //           courseMap.addAll({defrenceTime: webinar});
              //         } else {
              //           final webinar = FlashDb(
              //             content: freeWebinarContent,
              //             joinButton: widget.joinButton,
              //             dismissNotification: widget.dismissNotification,
              //             payment: payment,
              //             wbinarLive: currentWebinar,
              //           );
              //           currentWebinar.add(webinar);
              //         }
              //       }
              //       for (var i in timingList) {
              //         courseList.add(courseMap[i]);
              //       }
              //       return Container(
              //         child: Column(
              //           children: [
              //             currentWebinar.isEmpty
              //                 ? courseList[0]
              //                 : currentWebinar[0]
              //           ],
              //         ),
              //       );
              //     }
              //   },
              // ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: FlatButton(
                  child: Text(
                    "Upcoming",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        fontFamily: kfontname),
                  ),
                  height: 40,
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MobileWebinarCard()));
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => MobileJoinSuccessfully(
                    //               joinUserName: 'thashdsf',
                    //             )));
                  },
                ),
              ),
            ],
          ),
          IconButton(
              tooltip: 'Close Notification',
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: widget.dismissNotification),
        ],
      ),
    );
  }
}

class FlashDb extends StatefulWidget {
  Function joinButton;
  Function upcomingButton;
  Function dismissNotification;
  String joinButtonName = 'JOIN';
  List<Widget> wbinarLive;
  String content;
  String payment;
  FlashDb(
      {this.content,
      this.joinButton,
      this.dismissNotification,
      this.joinButtonName,
      this.payment,
      this.upcomingButton,
      this.wbinarLive});

  @override
  _FlashDbState createState() => _FlashDbState();
}

class _FlashDbState extends State<FlashDb> {
  var remaingTime = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('Webinar').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("Loading...");
            } else {
              var timeStamp;
              final time = snapshot.data.docs;
              for (var i in time) {
                print('uuuuuuuuuuuuuuuuuuuuuuuyyyyyyyyyyyyyyyyyyg');
                print(i.data()['course']);

                if (widget.content == i.data()['course']) {
                  timeStamp = i.data()['timestamp'];
                }
              }
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
              print('$defrenceTime testing timing');
              remaingTime = defrenceTime > 0 ? defrenceTime : 0;
              if (remaingTime != 0) {
                return SlideCountdownClock(
                  duration: Duration(seconds: remaingTime),
                  separator: ' : ',
                  textStyle: TextStyle(
                      fontSize: 25, fontFamily: kfontname, color: Colors.white),
                  separatorTextStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Ubuntu'),
                  shouldShowDays: true,
                  onDone: () {
                    setState(() {
                      remaingTime = 0;
                    });
                  },
                );
              } else {
                return Container(
                  // color: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'live Streaming Started',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                );
              }
            }
          },
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          height: 20,
          width: 2,
          color: Colors.white,
        ),
        RichText(
            text: TextSpan(
                style: TextStyle(color: Colors.white, fontSize: 20),
                children: [
              TextSpan(text: widget.content),
              TextSpan(
                  text: ' Value based webinar ',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: 'Now'),
            ])),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: FlatButton(
            child: Text(
              remaingTime != 0 ? 'Join' : 'Join Live',
              style: TextStyle(
                  color: remaingTime != 0 ? Colors.blue : Colors.red,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontFamily: kfontname),
            ),
            height: 40,
            color: Colors.white,
            onPressed: () {
              setState(() {
                Navbar.isNotification = false;
              });

              Provider.of<Routing>(context, listen: false).updateRouting(
                  widget: widget.wbinarLive.isEmpty
                      ? SingleWebinarScreen(
                          topic: widget.content,
                        )
                      : LiveWebinar(
                          course: widget.content,
                          payment: widget.payment,
                        ));
              Provider.of<MenuBar>(context, listen: false)
                  .updateMenu(widget: WebinarMenu());
            },
          ),
        ),
      ],
    );
  }
}
