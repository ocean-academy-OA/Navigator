import 'package:flutter/material.dart';
import 'package:ocean_project/desktopview/Components/enroll_new.dart';
import 'package:ocean_project/desktopview/Components/course_enrole.dart';
import 'package:ocean_project/desktopview/Components/enrool_appbar.dart';
import 'package:ocean_project/desktopview/Components/user_profile.dart';
import 'package:ocean_project/desktopview/screen/home_screen.dart';
import 'package:ocean_project/desktopview/screen/menubar.dart';
import 'package:ocean_project/desktopview/screen/course_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Routing extends ChangeNotifier {
  Widget route = Home();
  void isAlive() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = (prefs.getString('user') ?? null);
    route = username != null ? CoursesView() : Home();
  }

  Routing() {
    isAlive();
  }
  void updateRouting({Widget widget, String name}) {
    route = widget;
    notifyListeners();
  }
}

class MenuBar extends ChangeNotifier {
  Widget route = NavbarRouting();
  static String stayUser;

  String text;

  void isAlive() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = (prefs.getString('user') ?? null);
    route = username != null ? AppBarWidget() : NavbarRouting();
  }

  MenuBar() {
    isAlive();
  }
  Future<void> updateMenu({text, Widget widget}) async {
    route = widget;
    this.text = text;
    notifyListeners();
  }
}

class CourseProvide extends ChangeNotifier {
  Widget routing = CourseList();
  void updateCourseName({Widget routing, bool isCheck, int flex}) {
    this.routing = routing;
    notifyListeners();
  }
}

class SyllabusView extends ChangeNotifier {
  Widget routing = EnrollNew();
  void updateCourseSyllabus({
    Widget routing,
  }) {
    this.routing = routing;
    notifyListeners();
  }
}

class OALive extends ChangeNotifier {
  Widget route = Navbar();

  void updateOA({Widget routing}) {
    this.route = routing;
    notifyListeners();
  }
}

class UserProfiles extends ChangeNotifier {
  Widget route = User_Profile();

  void updateUser({Widget routing}) {
    this.route = routing;
    notifyListeners();
  }
}

class SliderContent extends ChangeNotifier {
  String title = "", description = "";

  void updateValue(String title, String description) {
    this.title = title;
    this.description = description;
    notifyListeners();
  }
}

class UpcomingModel extends ChangeNotifier {
  int flag = 0;

  void updateFlags(int flag) {
    this.flag = flag;
    notifyListeners();
  }
}

class CourseInfo extends ChangeNotifier {
  Widget route = VisibleProvider();
  void updateWebinar({Widget routing}) {
    this.route = routing;
    notifyListeners();
  }
}
