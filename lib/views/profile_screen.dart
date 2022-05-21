import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:housey/models/activity_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:housey/views/home_screen.dart';
import 'package:housey/views/main_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:housey/views/main_page.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'package:housey/widgets/BottomNavBar.dart';
import 'home_screen.dart';
import 'main_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final textcontroller = TextEditingController();
  final titlecontroller = TextEditingController();
  final datecontroller = TextEditingController();
  final maxpeople = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.reference();
  final authstate = FirebaseAuth.instance.currentUser;
  final authEmail = FirebaseAuth.instance.currentUser!.email;
  ActivityModel activity = ActivityModel();
  List<Map<dynamic, dynamic>> lists = [];
  List<Map<dynamic, dynamic>> activitylists = [];
  @override
  void initState() {
    super.initState();
    getUser();
    getActivitywithword(authEmail.toString());
  }

  Route _createRouteCreateHomePage() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => HomePage(
        title: 'Housey',
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).push(_createRouteCreateHomePage());
  }

  Future getUser() async {
    String authid = authstate!.uid;

    return await databaseRef

        //child olarak yazınca da oluyor activite id sini nasıl çekcem
        .child('users')
        .once()
        .then((DataSnapshot dataSnapshot) {
      print('savpaerlövşwövlşavöclşdscvöwdlşavcöw + ${dataSnapshot.value}');
      Map<dynamic, dynamic> values = dataSnapshot.value;

      values.forEach((key, values) {
        if (values['email'] == authEmail) {
          lists.add(values);
        }

        setState(() {
          print(lists);
        });
      });
    });
  }

  Future getActivitywithword(String word) async {
    //word=authstate!.email.toString();

    return await databaseRef

        //child olarak yazınca da oluyor activite id sini nasıl çekcem
        .child('activities')
        .once()
        .then((DataSnapshot dataSnapshot) {
      print('savpaerlövşwövlşavöclşdscvöwdlşavcöw + ${dataSnapshot.value}');
      print("vxcvxzbrbfgwagwaefwea  " + authEmail.toString());
      setState(() {
        Map<dynamic, dynamic> values = dataSnapshot.value;

        values.forEach((key, values) {
          if (values['ownername'].contains(word)) {
            activitylists.add(values);
          }
        });
        //activity = ActivityModel.fromSnapshot(dataSnapshot.value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        backgroundColor: (Colors.deepPurple),
        title: Text(
          'Profil',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: ElevatedButton(
              onPressed: () {
                logout(context);
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.purple[400],
                  minimumSize: Size(35.0, 40.0),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0))),
              child: Text('Çıkış yap'),
            ),
          ),
        ],
      ),
      body: Column(
        
        children: [
           IconButton(
               onPressed: () {
              //getActivitywithword('');
               },
               icon: Icon(Icons.portrait_rounded)),
                   Text(
                    authEmail!.replaceAll("@gmail.com", "").toString(),
                    //lists[0]["username"],
                 style: TextStyle(
                        fontSize: 22.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 60.0),
           Padding(
              padding: EdgeInsets.only(top: 15.0),
              child:   Text(
              'Oluşturduğum aktiviteler',
               style: TextStyle(
                 fontSize: 22.0,
                 fontStyle: FontStyle.italic,
                 fontWeight: FontWeight.w300,
                color: Colors.black,
                letterSpacing: 1.5,
               ),
              ),
            ),
            
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: activitylists.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //Text("Tarih: " + lists[index]["date"]),
                        //Text("Kişi sayısı: " + lists[index]["maxPeople"]),
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          leading: Container(
                            padding: EdgeInsets.only(right: 12.0),
                            decoration: new BoxDecoration(
                                border: new Border(
                                    right: new BorderSide(
                                        width: 1.0, color: Colors.white24))),
                            child: Icon(Icons.autorenew, color: Colors.white),
                          ),
                          title: Text("Başlık: " +
                              activitylists[index]["title"] +
                              "\nTarih: " +
                              activitylists[index]["date"] +
                              "\nKişi sayısı: " +
                              activitylists[index]["maxPeople"] +
                              "\nAktivite Sahibi: " +
                              activitylists[index]["ownername"]),
                          trailing: Icon(Icons.local_activity),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
      //     body: Column(
      //        crossAxisAlignment: CrossAxisAlignment.center,
      //           mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Column(

      //           children: [

      //               IconButton(
      //         onPressed: () {
      //          getActivitywithword('');
      //         },
      //         icon: Icon(Icons.portrait_rounded)),
      //             Text(
      //               authEmail!.replaceAll("@gmail.com", "").toString(),
      //               //lists[0]["username"],
      //               style: TextStyle(
      //                   fontSize: 22.0,
      //                   color: Colors.black,
      //                   fontWeight: FontWeight.bold),
      //             ),
      //           Text(
      //         "Bilgi",
      //         style: TextStyle(
      //           color: Colors.redAccent,
      //           fontStyle: FontStyle.normal,
      //           fontSize: 28.0,
      //         ),
      //       ),
      //       Text(
      //        'Oluşturduğum aktiviteler',
      //         style: TextStyle(
      //           fontSize: 22.0,
      //           fontStyle: FontStyle.italic,
      //           fontWeight: FontWeight.w300,
      //           color: Colors.black,
      //           letterSpacing: 2.0,
      //         ),
      //       ),
      //           ],
      //         ),
      //         Container(
      // child: Padding(
      //   padding: const EdgeInsets.symmetric(
      //       vertical: 30.0, horizontal: 40.0),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //     Expanded(
      //         child: ListView.builder(
      //   shrinkWrap: true,
      //   itemCount: lists.length,
      //   itemBuilder: (BuildContext context, int index) {
      //     return Card(
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: <Widget>[
      //           //Text("Tarih: " + lists[index]["date"]),
      //           //Text("Kişi sayısı: " + lists[index]["maxPeople"]),
      //           ListTile(
      //             contentPadding: EdgeInsets.symmetric(
      //                 horizontal: 10.0, vertical: 10.0),
      //             leading: Container(
      //               padding: EdgeInsets.only(right: 12.0),
      //               decoration: new BoxDecoration(
      //                   border: new Border(
      //                       right: new BorderSide(
      //                           width: 1.0, color: Colors.white24))),
      //               child: Icon(Icons.autorenew, color: Colors.white),
      //             ),
      //             title: Text("Başlık: " +
      //                 activitylists[index]["title"] +
      //                 "\nTarih: " +
      //                 activitylists[index]["date"] +
      //                 "\nKişi sayısı: " +
      //                 activitylists[index]["maxPeople"] +
      //                 "\nAktivite Sahibi: " +
      //                 activitylists[index]["ownername"]),
      //             trailing: Icon(Icons.local_activity),
      //           ),
      //         ],
      //       ),
      //     );
      //   }),
      //       ),
      //       Text(
      //               '',
      //               //activitylists[0]["title"],
      //               style: TextStyle(
      //                   fontSize: 22.0,
      //                   color: Colors.black,
      //                   fontWeight: FontWeight.normal),
      //             ),
      //     ],
      //   ),
      // )),
      //         SizedBox(
      //           height: 20,

      //         ),

      //       ],
      //     ),
      bottomNavigationBar: Bottom(),
    );
  }
}
