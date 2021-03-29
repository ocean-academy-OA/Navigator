import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:ocean_project/desktopview/new_user_screen/log_in.dart';
import 'package:ocean_project/desktopview/screen/course_details.dart';
import 'package:ocean_project/desktopview/Components/onlineDb.dart';
import 'package:ocean_project/desktopview/route/routing.dart';
import 'package:ocean_project/desktopview/Components/course_enrole.dart';
import 'dart:html';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _firestore = FirebaseFirestore.instance;

class EnrollNew extends StatefulWidget {
  bool isEnroll = false;
  static List availableBatch = [];

  @override
  _EnrollNewState createState() => _EnrollNewState();
}

class _EnrollNewState extends State<EnrollNew> {
  List<String> subjects = [];

  String courseId;

  getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    LogIn.registerNumber = (prefs.getString('user') ?? null);
  }

  @override
  void initState() {
    // TODO: implement initState

    getSession();
    super.initState();
  }

  List EnrollList = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/oa_bg.png'),
              repeat: ImageRepeat.repeatY)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection("new users").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading...");
                  } else {
                    final messages = snapshot.data.docs;

                    for (var message in messages) {
                      print("${LogIn.registerNumber}LogIn.registerNumber");
                      if (message.id == LogIn.registerNumber) {
                        EnrollList = message.data()['Courses'];
                        print("${EnrollList}EnrollList");
                      }
                    }
                  }
                  return StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('course').snapshots(),
                    // ignore: missing_return
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text("Loading...");
                      } else {
                        final messages = snapshot.data.docs;

                        List<EnrollCourseDb> courseList = [];

                        for (var message in messages) {
                          if (!EnrollList.any((element) =>
                              element.contains(message.data()["coursename"]))) {
                            final messageText = message.data()['trainername'];
                            final messageSender = message.data()['coursename'];
                            final messageSession = message.data()['session'];
                            final messageTime = message.data()['time'];
                            final messageImage = message.data()['img'];
                            final messageDescription =
                                message.data()['coursedescription'];
                            final messageBatchId = message.data()['batchid'];

                            final CourseDbVariable = EnrollCourseDb(
                              trainername: messageText,
                              coursename: messageSender,
                              session: messageSession,
                              time: messageTime,
                              image: messageImage,
                              description: messageDescription,
                              batchid: messageBatchId,
                            );
                            courseList.add(CourseDbVariable);
                          }
                        }
                        return Wrap(
                          alignment: WrapAlignment.center,
                          children: courseList,
                        );
                      }
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class EnrollCourseDb extends StatefulWidget {
  static bool visiblity = false;
  EnrollCourseDb(
      {this.coursename,
      this.trainername,
      this.session,
      this.time,
      this.image,
      this.description,
      this.batchid});
  final String coursename;
  final String trainername;
  final String session;
  final String time;
  final String image;
  final String description;
  final String batchid;

  @override
  _EnrollCourseDbState createState() => _EnrollCourseDbState();
}

class _EnrollCourseDbState extends State<EnrollCourseDb> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          EnrollCourseDb.visiblity = true;
        });
        setState(() {
          OnlineCourse.visiblity = true;
        });
        Provider.of<SyllabusView>(context, listen: false).updateCourseSyllabus(
            routing: CourseDetails(
          batch: widget.batchid,
          course: widget.coursename,
          trainer: widget.trainername,
          sess: widget.time,
          desc: widget.description,
        ));
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          margin: EdgeInsets.all(35.0),
          //padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          height: 310.0,
          width: 370.0,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  width: 350,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image(
                      image: NetworkImage('${widget.image}'),
                      fit: BoxFit.cover,
                      // width: 350.0,
                      // height: 100.0,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "${widget.coursename} full package course | ${widget.trainername} | Ocean Academy",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.schedule,
                          color: Color(0xff3B7EB6),
                        ),
                        Text("${widget.time} hr"),
                        Icon(
                          Icons.web_sharp,
                          color: Color(0xff3B7EB6),
                        ),
                        Text("${widget.session} sessions"),
                        Icon(
                          Icons.video_call,
                          color: Color(0xff3B7EB6),
                        ),
                        Text("by zoom"),
                        Text(
                          "Click Here",
                          style: TextStyle(
                            color: Color(0xff3B7EB6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
