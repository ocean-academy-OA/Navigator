import 'package:flutter/material.dart';
import 'package:ocean_project/desktopview/route/routing.dart';
import 'package:ocean_project/desktopview/screen/about_us_screen.dart';
import 'package:ocean_project/desktopview/screen/career/career_layout.dart';
import 'package:ocean_project/desktopview/screen/contact_us.dart';
import 'package:ocean_project/desktopview/screen/home_screen.dart';
import 'package:ocean_project/desktopview/screen/offline.dart';
import 'package:ocean_project/desktopview/screen/online.dart';
import 'package:ocean_project/desktopview/screen/services.dart';

import 'package:provider/provider.dart';

class OceanLive extends StatefulWidget {
  @override
  _OceanLiveState createState() => _OceanLiveState();
}

class _OceanLiveState extends State<OceanLive> {
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
        ChangeNotifierProvider(create: (context) => CourseInfo()),
        ChangeNotifierProvider(create: (context) => UserProfiles()),
        ChangeNotifierProvider(create: (context) => MenuBar()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Gilroy',
          ),
          initialRoute: Home.route,
          routes: {
            Home.route: (context) => Home(),
            AboutUs.route: (context) => AboutUs(),
            OnlineCourseNew.route: (context) => OnlineCourseNew(),
            OfflineCourseNew.route: (context) => OfflineCourseNew(),
            Service.route: (context) => Service(),
            CareerLayout.route: (context) => CareerLayout(),
            ContactUs.route: (context) => ContactUs(),
          },
          home: Home()),
    );
  }
}
