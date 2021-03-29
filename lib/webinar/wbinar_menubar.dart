import 'package:flutter/material.dart';
import 'package:ocean_project/desktopview/Components/course_enrole.dart';
import 'package:ocean_project/desktopview/Components/enrool_appbar.dart';
import 'package:ocean_project/desktopview/Components/ocean_icons.dart';
import 'package:ocean_project/desktopview/constants.dart';
import 'package:ocean_project/desktopview/new_user_screen/log_in.dart';
import 'package:ocean_project/desktopview/route/routing.dart';
import 'package:ocean_project/desktopview/screen/contact_us.dart';
import 'package:ocean_project/desktopview/screen/home_screen.dart';
import 'package:ocean_project/desktopview/screen/menubar.dart';
import 'package:ocean_project/webinar/webinar_const.dart';
import 'package:provider/provider.dart';

class WebinarMenu extends StatefulWidget {
  @override
  _WebinarMenuState createState() => _WebinarMenuState();
}

class _WebinarMenuState extends State<WebinarMenu> {
  @override
  Widget build(BuildContext context) {
    print("webinar login checking${MenuBar.stayUser}");
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 80,
      decoration: BoxDecoration(color: Colors.grey[100], boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: Offset(0, -4)),
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      NavbarRouting.menu.updateAll(
                          (key, value) => NavbarRouting.menu[key] = false);
                      NavbarRouting.menu["Home"] = true;
                    });
                    Provider.of<Routing>(context, listen: false)
                        .updateRouting(widget: Home());
                    Provider.of<MenuBar>(context, listen: false)
                        .updateMenu(widget: NavbarRouting());
                  },
                  child: Icon(
                    Ocean.oa,
                    size: 60,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  'ocean academy',
                  style: TextStyle(
                      fontFamily: 'Ubuntu',
                      inherit: false,
                      fontSize: 35,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            width: 400,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            width: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      NavbarRouting.menu.updateAll(
                          (key, value) => NavbarRouting.menu[key] = false);
                      NavbarRouting.menu["Contact Us"] = true;
                    });
                    Provider.of<Routing>(context, listen: false)
                        .updateRouting(widget: ContactUs());
                    Provider.of<MenuBar>(context, listen: false)
                        .updateMenu(widget: NavbarRouting());
                  },
                  child: Container(
                    child: Text(
                      'CONTACT',
                      style: TextStyle(
                          color: kBlue,
                          fontSize: 20,
                          fontFamily: kfontname,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      NavbarRouting.menu.updateAll(
                          (key, value) => NavbarRouting.menu[key] = false);
                    });
                    Provider.of<Routing>(context, listen: false).updateRouting(
                        widget:
                            MenuBar.stayUser == null ? LogIn() : CoursesView());
                    Provider.of<MenuBar>(context, listen: false).updateMenu(
                        widget: MenuBar.stayUser == null
                            ? NavbarRouting()
                            : AppBarWidget());
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: kBlue, width: 3),
                        borderRadius: BorderRadius.circular(100)),
                    child: Text(
                      'LOG IN',
                      style: TextStyle(
                          color: kBlue,
                          fontSize: 20,
                          fontFamily: kfontname,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
