import 'package:flutter/material.dart';
import 'package:ocean_project/desktopview/Components/enrool_appbar.dart';
import 'package:ocean_project/desktopview/constants.dart';
import 'package:ocean_project/desktopview/main.dart';
import 'package:ocean_project/desktopview/screen/career/career_layout.dart';
import 'package:ocean_project/desktopview/screen/contact_us.dart';

import 'package:ocean_project/desktopview/screen/menubar.dart';
import 'package:ocean_project/desktopview/screen/offline.dart';
import 'package:ocean_project/desktopview/screen/online.dart';
import 'package:ocean_project/mobileview/main.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'desktopview/Components/course_enrole.dart';
import 'desktopview/route/routing.dart';
import 'desktopview/screen/about_us_screen.dart';
import 'desktopview/screen/home_screen.dart';
import 'desktopview/screen/services.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(fontFamily: kfontname),
      debugShowCheckedModeBanner: false,
      home: ScreenTypeLayout(),
    ),
  );
}

class ScreenTypeLayout extends StatefulWidget {
  // Mobile will be returned by default
  @override
  _ScreenTypeLayoutState createState() => _ScreenTypeLayoutState();
}

class _ScreenTypeLayoutState extends State<ScreenTypeLayout> {
  final Widget mobile = OceanMobileView();
  final Widget tablet = OceanMobileView();
  final Widget desktop = OceanLive();
  String username;
  Widget route;
  Function customWidget;
  sessionfunction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = (prefs.getString('user') ?? null);
    print("${username}mainpage name");
    route = username != null
        ? Column(
            children: [
              Expanded(
                child: AppBarWidget(),
                flex: 0,
              ),
              Expanded(
                flex: 8,
                child: CoursesView(
                  userID: username,
                ),
              ),
            ],
          )
        : Home();
    print("${username}session mainpage");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sessionfunction();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Routing()),
        ChangeNotifierProvider(create: (context) => SliderContent()),
        ChangeNotifierProvider(create: (context) => UpcomingModel()),
        ChangeNotifierProvider(
          create: (context) => CourseProvide(),
        ),
        ChangeNotifierProvider(create: (context) => SyllabusView()),
        ChangeNotifierProvider(create: (context) => UserProfiles()),
        ChangeNotifierProvider(create: (context) => CourseInfo()),
        ChangeNotifierProvider(create: (context) => MenuBar()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Gilroy',
        ),
        initialRoute: Home.route,
        routes: {
          Home.route: (context) => Home(),
          AboutUs.route: (context) => AboutUs(),
          Service.route: (context) => Service(),
          OnlineCourseNew.route: (context) => OnlineCourseNew(),
          OfflineCourseNew.route: (context) => OfflineCourseNew(),
          CareerLayout.route: (context) => CareerLayout(),
          ContactUs.route: (context) => ContactUs(),
        },
        home: ResponsiveBuilder(builder: (context, sizingInformation) {
          if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
            print("desktop");
            if (desktop != null) {
              print("desktop");
              return OceanLive();
            }
          }
          return OceanMobileView();
        }),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
