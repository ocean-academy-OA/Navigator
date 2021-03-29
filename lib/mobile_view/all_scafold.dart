import 'package:flutter/material.dart';
import 'package:ocean_project/mobileview/components/ocean_icons.dart';
import 'package:ocean_project/mobileview/constants.dart';
import 'package:ocean_project/mobileview/screen/abouts_us_screen.dart';
import 'package:ocean_project/mobileview/screen/contact_us_screen.dart';
import 'package:ocean_project/mobileview/screen/courses_screen.dart';
import 'package:ocean_project/mobileview/screen/home_screen.dart';
import 'package:ocean_project/mobileview/screen/mobile_wbinar/webinar_list.dart';
import 'package:ocean_project/mobileview/screen/services_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class MobileScafold extends StatefulWidget {
  MobileScafold({this.widget, this.scaffoldKey});
  Widget widget = Home();
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  _MobileScafoldState createState() => _MobileScafoldState();
}

Map menu = {
  'Home': true,
  'About Us': false,
  'Service': false,
  'Course': false,
  'Contact Us': false,
};

class _MobileScafoldState extends State<MobileScafold> {
  Scaffold mobileViewAppBar(
      {Widget widget, GlobalKey<ScaffoldState> scaffoldKey}) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFFECF5FF),
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Color(0xFF155575),
          onPressed: () {
            scaffoldKey.currentState.openDrawer();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Ocean.oa,
              size: 35.0,
              color: Color(0xFF0091D2),
            ),
            Text(
              "ocean academy",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0091D2),
                  fontSize: 20),
            ),
          ],
        ),
        // bottom: PreferredSize(
        //     child: MobileFlashNotification(),
        //     preferredSize: Size.fromHeight(60)),
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('Webinar').snapshots(),
            builder: (context, snapshot) {
              print(snapshot.hasData);
              if (snapshot.hasData) {
                if (snapshot.data.docs.isNotEmpty) {
                  return IconButton(
                      tooltip: 'Upcoming Webinar',
                      icon: Icon(Icons.live_tv),
                      color: Colors.red,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MobileWebinarCard()));
                      });
                } else {
                  return IconButton(
                    tooltip: 'Webinar Not Available',
                    icon: Icon(Icons.live_tv),
                    color: Colors.red,
                  );
                }
              } else {
                return IconButton(
                  icon: Icon(Icons.live_tv),
                  color: Colors.red,
                );
              }
            },
          ),
        ],
      ),
      drawer: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 53),
            height: 300,
            child: Drawer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  menuItem(text: 'Home', widget: Home()),
                  menuItem(text: 'About', widget: AboutUs()),
                  menuItem(text: 'Service', widget: Service()),
                  menuItem(text: 'Courses', widget: Courses()),
                  menuItem(text: 'ContactUs', widget: ContactUs()),
                ],
              ),
            ),
          ),
        ],
      ),
      body: widget,
    );
  }

  GestureDetector menuItem({text, widget}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          menu.updateAll((key, value) => menu[key] = false);
          menu[text] = true;
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => widget));
      },
      child: Text(
        text,
        style: TextStyle(
            color: menu[text] == true ? Colors.blue : Color(0xFF155575),
            //color: Colors.red,
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            fontFamily: kfontname),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return mobileViewAppBar(
        scaffoldKey: widget.scaffoldKey, widget: widget.widget);
  }
}
