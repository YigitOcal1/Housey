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
  final authstate = FirebaseAuth.instance.currentUser;
  late ActivityModel activity;

  final Future<FirebaseApp> _future = Firebase.initializeApp();
  String displayTitle = 'burada görünecek';
  String displayDate = 'burada görünecek';
  String displayMaxpeople = 'burada görünecek';
  List<String> titleList = [];
  List<String> dateList = [];
  List<String> maxpeopleList = [];

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
          print(values["userid"]);
          displayTitle = values['title'];
          titleList.add(values['title']);
          print("olllllllllllllllllllllllll  " + values['title'].toString());
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
    //printFirebase();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: (Colors.orange[300]),
        title: Text('Aktivite listeleme ekranı'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.purple[400],
                  minimumSize: Size(55.0, 40.0),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50.0))),
              child: Text('Geri Dön'),
            ),
          )
        ],
      ),
      body: FutureBuilder(
          future: _future, // buraya methodu eklersen direkt çağırır
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 250.0),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        controller: titlecontroller,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                          children: []), //to do: liste şeklinde göstermedd
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(displayDate),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(displayMaxpeople),
                    ),
                    SizedBox(height: 30.0),
                    Center(
                        child: ElevatedButton(
                            child: Text("Aktivite göster"),
                            onPressed: () {
                              getActivity();
                            })),
                  ],
                ),
              );
            }
          }),
    );
  }
}
