import 'package:flutter/material.dart';
import 'package:ocean_project/alert/alert_msg.dart';
import 'package:ocean_project/mobile_view/all_scafold.dart';
import 'package:ocean_project/mobileview/components/how_it_works.dart';
import 'package:ocean_project/mobileview/components/main_badget_widget.dart';
import 'package:ocean_project/mobileview/components/placement_company.dart';
import 'package:ocean_project/mobileview/components/reviews.dart';
import 'package:ocean_project/mobileview/components/slider_widget.dart';
import 'package:ocean_project/mobileview/components/upcoming_course_widget.dart';
import 'package:ocean_project/mobileview/screen/footer.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Home extends StatelessWidget {
  Home({this.appBar});
  final AppBar appBar;
  GlobalKey<FormState> formKeyAlert = GlobalKey<FormState>();

  final keyIsFirstLoaded = 'is_first_loaded';

  String fullNameAlert;
  String phoneNumberAlert;
  String emailAlert;

  bool flag = true;

  GlobalKey<ScaffoldState> homeScaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => showDialogIfFirstLoaded(context));
    return MobileScafold(
      scaffoldKey: homeScaffoldKey,
      widget: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SliderWidget(),
              MainBadgeWidget(),
              UpcomingCourse(),
              PlacementCompany(),
              ReviewsSection(),
              HowItWorks(),
              Footer(),
            ],
          ),
        ),
      ),
    );
  }

  Future showDialogIfFirstLoaded(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLoaded = prefs.getBool(keyIsFirstLoaded);
    var alertStyle = AlertStyle(
        animationType: AnimationType.fromTop,
        isCloseButton: flag,
        isOverlayTapDismiss: true,
        descStyle: TextStyle(fontWeight: FontWeight.bold),
        animationDuration: Duration(milliseconds: 400),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          // side: BorderSide(color: Colors.red),
        ),
        titleStyle: TextStyle(
            color: Colors.black54, fontWeight: FontWeight.w700, fontSize: 25),
        constraints: BoxConstraints.expand(width: 5000, height: 1000),
        //First to chars "55" represents transparency of color
        overlayColor: Color(0x55000000),
        alertElevation: 100,
        alertAlignment: Alignment.topCenter);

    /// TODO insted of true = null
    if (isFirstLoaded == true) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertEnquiry(buttonName: 'Submit');
        },
      );
    }
  }
}
