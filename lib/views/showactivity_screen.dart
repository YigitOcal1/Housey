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
  List<Map<dynamic, dynamic>> lists = [];

  final Future<FirebaseApp> _future = Firebase.initializeApp();
  String displayTitle = 'burada görünecek';
  String displayDate = 'burada görünecek';
  String displayMaxpeople = 'burada görünecek';
  String displayError = '';
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

  Future getActivitywithword(String word) async {
    String authid = authstate!.uid;
    return await databaseRef

        //child olarak yazınca da oluyor activite id sini nasıl çekcem
        .once()
        .then((DataSnapshot dataSnapshot) {
      //print('savpaerlövşwövlşavöclşdscvöwdlşavcöw + ${dataSnapshot.value}');
      setState(() {
        Map<dynamic, dynamic> values = dataSnapshot.value;
        values.forEach((key, values) {
          if (values['title'] == word || values['title'] == word + " ") {
            lists.add(values);
          } else { //bir kere daha boş olarak geldiği için else dönüyor.
            displayError =
                "SONUÇ BULUNAMADI. Lütfen doğru arama yaptığınızdan emin olunuz.";
          }

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
    //printFirebase();
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        backgroundColor: (Colors.deepPurple),
        title: Text(
          'Aktivite listeleme',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            //  padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Material(
                color: Colors.white,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration.collapsed(
                            hintText:
                                'Aktivite aramak için bir sözcük giriniz.'),
                        onSubmitted: (value) {
                          getActivitywithword(value);
                        },
                      ),
                    ),
                    InkWell(
                      child: Icon(
                        Icons.local_activity,
                        color: Colors.grey,
                      ),
                      onTap: () {},
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
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
      body: Column(
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
          Text(displayError),
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
  }
}
