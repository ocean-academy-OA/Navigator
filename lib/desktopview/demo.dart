import 'package:flutter/material.dart';
import 'package:ocean_project/desktopview/screen/about_us_screen.dart';
import 'package:ocean_project/desktopview/screen/contact_us.dart';
import 'package:ocean_project/desktopview/screen/home_screen.dart';
import 'package:ocean_project/desktopview/screen/services.dart';

void main() {
  runApp(MaterialApp(home: MyHomePage()));
}

// class Demo extends StatefulWidget {
//   @override
//   _DemoState createState() => _DemoState();
// }
//
// class _DemoState extends State<Demo> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 RaisedButton(onPressed: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => Contain1()));
//                 }),
//                 RaisedButton(onPressed: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => Contain2()));
//                 }),
//                 RaisedButton(onPressed: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => Contain3()));
//                 }),
//                 RaisedButton(onPressed: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => Contain4()));
//                 })
//               ],
//             ),
//             Contain1(),
//             Contain2(),
//             Contain3(),
//             Contain4(),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class Contain1 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Row(
//             children: [
//               RaisedButton(onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => Contain1()));
//               }),
//               RaisedButton(onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => Contain2()));
//               }),
//               RaisedButton(onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => Contain3()));
//               }),
//               RaisedButton(onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => Contain4()));
//               })
//             ],
//           ),
//           Contain1(),
//           Container(
//             color: Colors.red,
//             height: 500,
//             width: 500,
//           ),
//           Contain3(),
//           Contain4(),
//         ],
//       ),
//     );
//   }
// }
//
// class Contain2 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Container(
//             color: Colors.pink,
//             height: 500,
//             width: 500,
//           ),
//           Contain3(),
//           Contain4(),
//         ],
//       ),
//     );
//   }
// }
//
// class Contain3 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.blue,
//       height: 500,
//       width: 500,
//     );
//   }
// }
//
// class Contain4 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.purple,
//       height: 500,
//       width: 500,
//     );
//   }
// }

class MyHomePage extends StatelessWidget {
  var list = ["Home", "AboutUs", "Service", "ContactUs"];
  var colors = [Colors.orange, Colors.blue, Colors.red, Colors.green];
  List<Widget> oa = [Home(), AboutUs(), Service(), ContactUs()];

  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)),
              ),
              Spacer(),
              Row(
                children: List.generate(3, (index) {
                  return GestureDetector(
                    onTap: () {
                      _scrollToIndex(index);
                    },
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: Text(list[index + 1]),
                    ),
                  );
                }),
              )
            ],
          ),
          Expanded(
            child: PageView(
                scrollDirection: Axis.vertical,
                pageSnapping: false,
                controller: controller,
                children: List.generate(list.length, (index) {
                  return oa[index];
                })),
          ),
        ],
      )),
    );
  }

  void _scrollToIndex(int index) {
    controller.animateToPage(index + 1,
        duration: Duration(seconds: 2), curve: Curves.fastLinearToSlowEaseIn);
  }
}
