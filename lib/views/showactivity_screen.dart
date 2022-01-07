import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:housey/models/activity_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShowActivity extends StatefulWidget {
  @override
  _ShowActivityState createState() => _ShowActivityState();
}

class _ShowActivityState extends State<ShowActivity> {
  final textcontroller = TextEditingController();
  final titlecontroller = TextEditingController();
  final datecontroller = TextEditingController();
  final maxpeople = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.reference().child('activities');
  List<Map<dynamic, dynamic>> lists = [];
  final authstate = FirebaseAuth.instance.currentUser;
  late ActivityModel activity;

  final Future<FirebaseApp> _future = Firebase.initializeApp();
  String displayTitle = 'burada görünecek';
  String displayDate = 'burada görünecek';
  String displayMaxpeople = 'burada görünecek';

  Future getActivity() async {
    String authid = authstate!.uid;
    return await databaseRef
        //child olarak yazınca da oluyor activite id sini nasıl çekcem
        .once()
        .then((DataSnapshot dataSnapshot) {
      //print('savpaerlövşwövlşavöclşdscvöwdlşavcöw + ${dataSnapshot.value}');
      setState(() {
        Map<dynamic, dynamic> values = dataSnapshot.value;
        values.forEach((key, values) {
          lists.add(values);        
          print(lists);
          print(values["userid"]);
          displayTitle = values['title'];
          //print("titledebug  " + displayTitle);
          //print(values["title"]);
          displayDate = values['date'];
          displayMaxpeople = values['peoplenumber'];
        });
        //activity = ActivityModel.fromSnapshot(dataSnapshot.value);
      });
    });
  }

  void printFirebase() {
    databaseRef.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
    });
  }

  @override
   Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("widget.title!"),
            actions: <Widget>[
         
        ],
        ),
        body:   Column(
          children: [
            Expanded(
              child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: lists.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Başlık: " + lists[index]["title"]),
                                  Text("Tarih: " + lists[index]["date"]),
                                  Text("Kişi sayısı: " + lists[index]["peoplenumber"]),                                  
                                ],
                              ),                              
                            );
                          }),
            ),
           ElevatedButton(
                        onPressed: () {
                         getActivity();
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.redAccent,
                            minimumSize: Size(85.0, 40.0),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(50.0))),
                        child: Text('Aktivite listele'),
                      ),
          ],
        ),         
            );
  }}







