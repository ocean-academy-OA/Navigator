import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ocean_project/mobileview/screen/mobile_wbinar/webinar_list.dart';
import 'package:ocean_project/webinar/join_successfully.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MobileWebinarCard(),
    ),
  );
}

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class TextingFirebase extends StatefulWidget {
  @override
  _TextingFirebaseState createState() => _TextingFirebaseState();
}

// getDbData() async {
//   var webinarCollection = await _firestore.collection('Webinar');
//   var webinar = await webinarCollection.get();
//
//   for (var a in webinar.docs) {
//     print(a.id);
//
//     var b = a.data();
//
//     for (var c in b.entries) {
//       print(c.value);
//       var subCollection =
//           await webinarCollection.doc(a.id).collection(c.value).get();
//       for (var d in subCollection.docs) {
//         print(d.data()['payment']);
//       }
//     }
//   }
// }
//
// subscribeDialog(context) {
//   return showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       Future.delayed(Duration(seconds: 3), () {
//         Navigator.pop(context);
//       });
//       return AlertDialog(
//         contentPadding: EdgeInsets.zero,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         backgroundColor: Colors.transparent,
//         content: Container(
//           height: 300,
//           width: 250,
//           decoration: BoxDecoration(
//               color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Thanks for Subscribe',
//                 style: TextStyle(fontSize: 25, color: Colors.grey),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Image.network(
//                   'https://tetranoodle.com/wp-content/uploads/2018/07/tick-gif.gif'),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
//
// List<dynamic> course = ['Python'];
// List<dynamic> courses = ['Flask', 'Python', 'Java'];
//
// courseTest() {
//   for (var i in courses) {
//     if (!course.any((e) => e.contains(i))) {
//       print(i);
//     }
//   }
// }

final numbrerList = List.generate(50, (index) => index + 1);

showJoinDialog(context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('hi'),
          actions: [
            TextButton(
              child: Text('Join'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => JoinSuccessfully()));
              },
            ),
          ],
        );
      });
}

// payment(List userId) async {
//   List<Widget> datas = [];
//   var allpayment = await _firestore
//       .collection('new users')
//       .doc(userId[0])
//       .collection('payment')
//       .get();
//   var paymentData = allpayment.docs;
//   for (var j in paymentData) {
//     final date = j.data()['date'];
//     final coursename = j.data()['coursename'];
//     final amount = j.data()['amount'];
//     final image = j.data()['image'];
//     final paid_via = j.data()['paid_via'];
//     final status = j.data()['status'];
//     Column singleData = Column(
//       children: [
//         Text(date),
//         Text(coursename),
//         Text(amount),
//         Text(image),
//         Text(paid_via),
//         Text(status),
//       ],
//     );
//     datas.add(singleData);
//   }
//   return Column(children: [Text('hi')]);
// }
//
// Widget paymentStreem(String userId) {
//   return StreamBuilder<QuerySnapshot>(
//       stream: _firestore
//           .collection('new users')
//           .doc(userId)
//           .collection('payment')
//           .snapshots(),
//       builder: (contex, snapshot) {
//         if (snapshot.hasData) {
//           return Text('test...');
//         } else {
//           var paymentData = snapshot.data.docs;
//           for (var j in paymentData) {
//             final date = j.data()['date'];
//             final coursename = j.data()['coursename'];
//             final amount = j.data()['amount'];
//             final image = j.data()['image'];
//             final paid_via = j.data()['paid_via'];
//             final status = j.data()['status'];
//             print(j.data());
//           }
//           return Text('testr..');
//         }
//       });
// }

class _TextingFirebaseState extends State<TextingFirebase> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('new users')
          .snapshots(includeMetadataChanges: true),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text('if...');
        } else {
          var test = snapshot.data.docs;
          for (var i in test) {
            print(i.id);
          }
          return Text('222222222');
        }
      },
    );
  }
}
