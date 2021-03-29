import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ocean_project/desktopview/route/routing.dart';
import 'package:ocean_project/practice/testing.dart';
import 'package:ocean_project/webinar/join_successfully.dart';
import 'package:ocean_project/webinar/webinar_const.dart';
import 'package:provider/provider.dart';

class LiveWebinar extends StatefulWidget {
  LiveWebinar({this.course, this.payment});
  String course;
  String payment;

  String name;
  String phoneNumber;
  String email;
  int studentEnrolled;
  @override
  _LiveWebinarState createState() => _LiveWebinarState();
}

class _LiveWebinarState extends State<LiveWebinar> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  bool isPlay = false;

  Widget _buildName() {
    return TextFormField(
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s")),
        LengthLimitingTextInputFormatter(40),
      ],
      validator: (value) {
        if (value.isEmpty) {
          return 'name is required';
        } else if (value.length < 3) {
          return 'character should be morethan 2';
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.drive_file_rename_outline),
        errorStyle: TextStyle(color: Colors.redAccent, fontSize: 12),
        border: OutlineInputBorder(),
        hintText: "enter your name",
        labelText: 'Name',
      ),
      controller: nameController,
      onChanged: (value) {
        widget.name = value;
      },
    );
  }

  Widget _buildphonenumber() {
    return TextFormField(
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(
          RegExp(r"^\d+\.?\d{0,2}"),
        ),
        LengthLimitingTextInputFormatter(10),
      ],
      validator: (value) {
        if (value.isEmpty) {
          return 'phone_number is required';
        } else if (value.length < 10) {
          return 'invalid phone_number';
        }
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.phone_android_outlined),
        errorStyle: TextStyle(color: Colors.redAccent, fontSize: 12),
        border: OutlineInputBorder(),
        hintText: 'Enter Your Number',
        labelText: 'Phone Number',
      ),
      controller: phoneNumberController,
      onChanged: (value) {
        widget.phoneNumber = value;
      },
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s"))],
      validator: (value) =>
          EmailValidator.validate(value) ? null : "please enter a valid email",
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email_outlined),
        errorStyle: TextStyle(color: Colors.redAccent, fontSize: 12),
        border: OutlineInputBorder(),
        hintText: 'Enter Your Email',
        labelText: 'Email',
      ),
      controller: emailController,
      onChanged: (value) {
        widget.email = value;
      },
    );
  }

  // void getData() async {
  //   http.Response response = await http.get(
  //       """ https://shrouded-fjord-03855.herokuapp.com/?name=${widget.name}&des=query&mobile=${widget.phoneNumber}&email=${widget.email}&date=date time &type=enquiry""");
  //
  //   if (response.statusCode == 200) {
  //     String data = response.body;
  //     print(data);
  //   } else {
  //     print(response.statusCode);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Row(
      children: [
        Column(
          children: [
            Spacer(),
            Image.network('images/webinar/wbinar live.svg'),
            Spacer(),
          ],
        ),
        SizedBox(
          width: 100,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              '${widget.course.toUpperCase()} ${widget.payment.toUpperCase()}',
              style: TextStyle(fontSize: 50),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 500,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Container(
                      height: 240,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildName(),
                          _buildphonenumber(),
                          _buildEmail(),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    child: MaterialButton(
                        child: Text(
                          'Join Live Now',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        color: kBlue,
                        minWidth: double.infinity,
                        height: 60,
                        elevation: 0,
                        hoverElevation: 0,
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            if (widget.name != null &&
                                widget.email != null &&
                                widget.phoneNumber != null) {
                              if (widget.payment == 'free') {
                                print(' dddddddd   ${widget.studentEnrolled}');
                                var studentEnrolled = await _firestore
                                    .collection('Webinar')
                                    .doc(widget.course)
                                    .get();
                                int sudentEndrolld = int.parse(
                                    studentEnrolled.data()['student enrolled']);
                                await _firestore
                                    .collection('webinar Users')
                                    .doc('+91 ${widget.phoneNumber}')
                                    .set({
                                  'name': widget.name,
                                  'email': widget.email,
                                  'Phone_Number': '+91 ${widget.phoneNumber}',
                                  'payment': widget.payment == 'free'
                                      ? 'free'
                                      : widget.payment
                                });

                                _firestore
                                    .collection('Webinar')
                                    .doc('${widget.course}')
                                    .update({
                                  'student enrolled': '${sudentEndrolld + 1}'
                                });
                                Provider.of<MenuBar>(context, listen: false)
                                    .updateMenu(widget: SizedBox());
                                Provider.of<Routing>(context, listen: false)
                                    .updateRouting(
                                        widget: JoinSuccessfully(
                                            joinUserName: widget.name));
                              } else {
                                ///TODO payment Function
                                showJoinDialog(context);
                                print('pement function');
                              }
                            }
                            // getData();
                            nameController.clear();
                            emailController.clear();
                            phoneNumberController.clear();
                          }
                        }),
                  ),
                ],
              ),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
