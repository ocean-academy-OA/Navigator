import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ocean_project/desktopview/Components/onlineDb.dart';
import 'package:ocean_project/desktopview/constants.dart';
import 'package:ocean_project/desktopview/new_user_screen/log_in.dart';
import 'package:ocean_project/desktopview/route/routing.dart';
import 'package:ocean_project/desktopview/screen/course_details.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'zoom_integration.dart';

Map<String, String> courses_icon = {
  'C':
      'https://firebasestorage.googleapis.com/v0/b/ocean-live.appspot.com/o/courses_icon%2Fc.png?alt=media&token=4e2c22c6-8364-4bfc-b49e-d9fdab591bba',
};
final _firestore = FirebaseFirestore.instance;

// ignore: must_be_immutable
class HorizontalMenu extends StatefulWidget {
  List<String> courseList = [];
  static Widget customWidget;
  Map menu = {};
  List<String> batchId = [];
  List<String> courseIcon = [];
  HorizontalMenu({this.courseList, this.menu, this.batchId, this.courseIcon});
  @override
  _HorizontalMenuState createState() => _HorizontalMenuState();
}

class _HorizontalMenuState extends State<HorizontalMenu> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('${widget.courseList} widget.courseList ');
    //HorizontalMenu.customWidget = EnrollNew();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.courseList.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(10.0),
            child: MouseRegion(
              child: ListTile(
                hoverColor: Colors.white,
                leading: ClipRRect(
                  child: Container(
                      height: 40,
                      width: 40,
                      child: Icon(
                        FontAwesomeIcons.graduationCap,
                        color: Colors.white,
                      )),
                  borderRadius: BorderRadius.circular(500),
                ),
                title: MouseRegion(
                  child: courseEnroll(
                    text: widget.courseList[index],
                    color: widget.menu[index],
                  ),
                ),
                onTap: () {
                  print("welcome batchid ${widget.batchId[index]}");
                  setState(() {
                    widget.menu
                        .updateAll((key, value) => widget.menu[key] = false);
                    widget.menu[index] = true;
                  });
                  Provider.of<SyllabusView>(context, listen: false)
                      .updateCourseSyllabus(
                    routing: ContentWidget(
                      course: widget.courseList[index],
                      batchid: widget.batchId[index],
                      //batchid: "OCNBK08",
                    ),
                  );
                },
              ),
            ),
          );
        });
  }
}

Widget courseEnroll({text, color}) {
  return Text(
    text,
    style: TextStyle(
      color: color == true ? Colors.blue : Colors.white,
      fontSize: 20.0,
    ),
  );
}

// ignore: must_be_immutable
class CoursesView extends StatefulWidget {
  static String courseEnroll;
  static String studentname;

  static String studentemail;
  static List batchId = [];

  String course;
  String trainer;
  String sess;
  String desc;
  bool isEnroll = false;
  String userID;
  bool visible;

  CoursesView(
      {this.course,
      this.sess,
      this.trainer,
      this.desc,
      this.userID,
      this.visible});
  @override
  _CoursesViewState createState() => _CoursesViewState();
}

class _CoursesViewState extends State<CoursesView> {
  void batch_id() async {
    print("---------------------------");
    print("${LogIn.registerNumber}register number");
    await for (var snapshot in _firestore
        .collection('new users')
        .where("Phone Number", isEqualTo: LogIn.registerNumber)
        .snapshots(includeMetadataChanges: true)) {
      for (var message in snapshot.docs) {
        CoursesView.batchId = message.data()['batchid'];
      }
    }

    print("---------------------------");
  }

  bool visibility = true;

  getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    LogIn.registerNumber = (prefs.getString('user') ?? null);
    userCourses();
    batch_id();
    print("${CoursesView.batchId}CoursesView.batchId");
  }

  @override
  void initState() {
    getSession();

    // TODO: implement initState
    super.initState();
  }

  String batchid;
  String test;

  userCourses() async {
    var course = await _firestore
        .collection("new users")
        .doc(LogIn.registerNumber)
        .get();
    CoursesView.courseEnroll = course.data()["First Name"];
    CoursesView.studentemail = course.data()["E Mail"];
    print('${CoursesView.courseEnroll}CoursesView.courseEnroll');
  }

  @override
  Widget build(BuildContext context) {
    Map menu = {};
    return MaterialApp(
      theme: ThemeData(fontFamily: kfontname),
      home: Scaffold(
        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(100),
        //   child: AppBarWidget(),
        // ),
        body: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    //width: 250.0,
                    color: Color(0xff006793),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          //color: Color(0xff006793).withOpacity(0.5),
                          child: Column(
                            children: [
                              Text(
                                "Courses",
                                style: TextStyle(
                                  fontSize: 30.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: _firestore
                                    .collection('new users')
                                    .snapshots(),
                                // ignore: missing_return
                                builder: (context1, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Text("Loading...");
                                  } else {
                                    final messages = snapshot.data.docs;

                                    //userCourses();
                                    int pos = 0;
                                    List<String> courseList = [];
                                    List<String> courseIconList = [];
                                    List<String> batchId = [];

                                    for (var message in messages) {
                                      if (message.id == LogIn.registerNumber) {
                                        final messageSender =
                                            message.data()['Courses'];

                                        final batch = message.data()['batchid'];

                                        for (var i in messageSender) {
                                          menu[pos++] = false;
                                          courseList.add(i);
                                          courseIconList.add(courses_icon[i]);
                                        }
                                        for (var i in batch) {
                                          batchId.add(i);
                                        }
                                      }
                                    }

                                    return HorizontalMenu(
                                      courseList: courseList,
                                      menu: menu,
                                      batchId: batchId,
                                      courseIcon: courseIconList,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    child: Consumer<SyllabusView>(
                        builder: (context, routing, child) {
                      return routing.routing;
                    }),
                  ),
                )
              ],
            ),
            Consumer<UserProfiles>(builder: (context, routing, child) {
              return routing.route;
            }),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ContentWidget extends StatefulWidget {
  static bool isVisible = false;
  static bool isShow = false;
  String course;
  String batchid;
  String trainername;
  String description;
  String duration;
  String startDate;

  ContentWidget(
      {this.course,
      this.batchid,
      this.trainername,
      this.duration,
      this.description,
      this.startDate});

  @override
  _ContentWidgetState createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  String description;
  String trainername;

  userCoursesName() async {
    var course =
        await _firestore.collection("course").doc(widget.batchid).get();
    description = course.data()["coursedescription"];
    trainername = course.data()["trainername"];
  }

  var time;
  var date;
  List timeCalculation = [];
  String resolve;

  getTime() async {
    print("______________________________________");
    await for (var snapshot in _firestore
        .collection('course')
        .doc(widget.batchid)
        .collection("schedule")
        .snapshots(includeMetadataChanges: true)) {
      for (var message in snapshot.docs) {
        time = message.data()['time'];
        date = message.data()['date'];
        print(time);
        int startYear = 6;
        int endYear = 10;
        int startMonth = 3;
        int endMonth = 5;
        int startDay = 0;
        int endDay = 2;
        int startHour = 0;
        int endHour = 2;
        int startMinute = 3;
        int endMinute = 5;
        int startAm = 6;
        int endEm = 8;

        String year = date.substring(startYear, endYear);
        print("year${year}");
        String month = date.substring(startMonth, endMonth);
        print("month${month}");
        String day = date.substring(startDay, endDay);
        print("day${day}");
        int hour = int.parse(time.substring(startHour, endHour));
        print("hour${hour}");
        String minute = time.substring(startMinute, endMinute);
        print("minute${minute}");
        String morning = time.substring(startAm, endEm);
        print("morning${morning}");
        var dt = DateTime(
          int.parse(year),
          int.parse(month),
          int.parse(day),
          morning == "AM" ? hour : hour + 12,
          int.parse(minute),
        );
        var second = dt.difference(DateTime.now()).inSeconds;
        timeCalculation.add(second);
        print("${dt}${morning}datetime");
        print(DateTime.now());
        print(timeCalculation);
        for (var i in timeCalculation) {
          if (i > -3600 && i < 600) {
            resolve = "true";
            print(resolve);
            break;
          } else {
            resolve = "false";
            print(resolve);
          }
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userCoursesName();
    print("______________________________________");
    getTime();
  }

  @override
  Widget build(BuildContext context) {
    print("OA  batchid${widget.batchid}");
    return Container(
      //margin: const EdgeInsets.all(15.0),
      padding: EdgeInsets.all(40.0),
      width: 1300,
      height: double.infinity,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "☺",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Hi ${CoursesView.courseEnroll},you are enroll in ${widget.course} course",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textBaseline: TextBaseline.ideographic,
              children: [
                Row(
                  children: [
                    OutlineButton(
                      borderSide: BorderSide(color: Colors.blue),
                      padding: EdgeInsets.symmetric(
                          horizontal: 35.0, vertical: 17.0),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50.0),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          OnlineCourse.visiblity = false;
                        });
                        Provider.of<SyllabusView>(context, listen: false)
                            .updateCourseSyllabus(
                                routing: CourseDetails(
                          course: widget.course,
                          trainer: trainername,
                          sess: widget.startDate,
                          desc: description,
                          batch: widget.batchid,
                        ));
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.menu_book,
                            color: Color(0xFF0091D2),
                            size: 30.0,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "View Syllabus",
                            style: TextStyle(
                              color: Color(0xFF0091D2),
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('course')
                  .doc(widget.batchid)
                  .collection("schedule")
                  .snapshots(),
              // ignore: missing_return
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text("Loading...");
                } else {
                  final messages = snapshot.data.docs;
                  List<CourseContent> courseContent = [];
                  //List<String> subjects = [];
                  for (var message in messages) {
                    //if ((message.data()['coursename'] == widget.course)) {
                    final messageText = message.data()['date_and_time'];
                    final messagebatch = message.data()['description'];
                    final meetingNumber = message.data()['zoom_link'];
                    final password = message.data()['zoom_password'];
                    final messageFinish = message.data()['finish'];
                    final messageCoursedescription =
                        message.data()['description'];
                    final messageTopic = message.data()['topicCover'];
                    final messageContent1 = message.id;
                    final messageContent2 = message.data()['date'];
                    final messageContent3 = message.data()['time'];
                    final messageContent = CourseContent(
                      name: messageText,
                      coursename: widget.course,
                      finish: messageFinish,
                      coursedescription: messageCoursedescription,
                      topicCover: messageTopic,
                      title: messageContent1,
                      date: messageContent2,
                      time: messageContent3,
                      meetingPassword: password,
                      batchid: messagebatch,
                      meeting: meetingNumber,
                      result: resolve,
                      onpress: () {
                        print(password);
                        print("++++++++++++++++@@@@@@@@@@@");
                        print(meetingNumber);
                        print(
                            "https://brindakarthik.github.io/zoom/?meetingNumber=$meetingNumber&username=abc&password=$password");
                        Provider.of<SyllabusView>(context, listen: false)
                            .updateCourseSyllabus(
                                routing: ZoomIntegration(
                          zoomLink:
                              "https://brindakarthik.github.io/zoom/?meetingNumber=$meetingNumber&username=abc&password=$password",
                        ));
                      },
                    );
                    courseContent.add(messageContent);
                    //  }
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: courseContent,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CourseContent extends StatefulWidget {
  final String coursename;
  final String meetingPassword;
  final String name;
  final String finish;
  final String coursedescription;
  final String batchid;
  final String topicCover;
  final String title;
  final String time;
  final String date;
  final String schedule;
  final String meeting;
  final Function onpress;
  final String result;
  CourseContent(
      {this.coursename,
      this.batchid,
      this.meeting,
      this.name,
      this.finish,
      this.coursedescription,
      this.title,
      this.time,
      this.date,
      this.schedule,
      this.topicCover,
      this.onpress,
      this.result,
      this.meetingPassword});

  @override
  _CourseContentState createState() => _CourseContentState();
}

class _CourseContentState extends State<CourseContent> {
  @override
  Widget build(BuildContext context) {
    String zoomLink =
        "https://brindakarthik.github.io/zoom/?meetingNumber=${widget.meeting}&username=abc&password=${widget.meetingPassword}";
    print("${CoursesView.courseEnroll}CoursesView.courseEnroll");
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  //margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(15.0),
                  //height: 300.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.title}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Text("${widget.coursedescription}"),
                      SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        "Scheduled At",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.calendar_today_outlined),
                              Text("${widget.date}"),
                              SizedBox(
                                width: 20.0,
                              ),
                              Icon(Icons.access_time),
                              Text("${widget.time}"),
                            ],
                          ),
                          Row(
                            children: [
                              MaterialButton(
                                padding: EdgeInsets.all(20.0),
                                color: widget.result == "true"
                                    ? Colors.blue
                                    : Colors.grey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(05.0))),
                                onPressed: widget.onpress,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.videocam,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      "Join here",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CourseList extends StatefulWidget {
  @override
  _CourseListState createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  Map menu = {};
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      //width: 250.0,
      color: Color(0xff006793),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            //color: Color(0xff006793).withOpacity(0.5),
            child: Column(
              children: [
                Text(
                  "Courses",
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('new users').snapshots(),
                  // ignore: missing_return
                  builder: (context1, snapshot) {
                    if (!snapshot.hasData) {
                      return Text("Loading...");
                    } else {
                      final messages = snapshot.data.docs;

                      //userCourses();
                      int pos = 0;
                      List<String> courseList = [];
                      List<String> courseIconList = [];
                      List<String> batchId = [];

                      for (var message in messages) {
                        if (message.id == LogIn.registerNumber) {
                          final messageSender = message.data()['Courses'];
                          final batch = message.data()['batchid'];
                          for (var i in messageSender) {
                            menu[pos++] = false;
                            courseList.add(i);
                            courseIconList.add(courses_icon[i]);
                          }
                          for (var i in batch) {
                            batchId.add(i);
                          }
                        }
                      }

                      return HorizontalMenu(
                        courseList: courseList,
                        menu: menu,
                        batchId: batchId,
                        courseIcon: courseIconList,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
