import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:housey/models/activity_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:housey/views/main_page.dart';
import 'profile_screen.dart';
import 'package:housey/widgets/BottomNavBar.dart';

class ShowActivity extends StatefulWidget {
  @override
  _ShowActivityState createState() => _ShowActivityState();
}

class _ShowActivityState extends State<ShowActivity> {
  final textcontroller = TextEditingController();
  final titlecontroller = TextEditingController();
  final datecontroller = TextEditingController();
  final maxpeople = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.reference();
  final authstate = FirebaseAuth.instance.currentUser;
  ActivityModel activity = ActivityModel();
  List<Map<dynamic, dynamic>> lists = [];

  final Future<FirebaseApp> _future = Firebase.initializeApp();
  String displayTitle = 'burada görünecek';
  String displayDate = 'burada görünecek';
  String displayMaxpeople = 'burada görünecek';
  String displayUsername = '';
  String displayError = '';
  List<String> titleList = [];
  List<String> dateList = [];
  List<String> maxpeopleList = [];

  Route _createRouteCreateActivity() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => MainPage(),
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


  Future getActivity() async {
    String authid = authstate!.uid;

    //child olarak yazınca da oluyor activite id sini nasıl çekcem
    return await databaseRef
        .child('activities')
        .once()
        .then((DataSnapshot dataSnapshot) {
      //final LinkedHashMap value =dataSnapshot.value;

      //print(value);
      //print("data okundu ::   "+dataSnapshot.value.toString());
      //rint("wqewq fasdxxx "+value['title']);
      //activity=ActivityModel.fromMap(value);

      //print("title demene "+activity.toString());
      //print('savpaerlövşwövlşavöclşdscvöwdlşavcöw + ${dataSnapshot.value}');
      setState(() {
        Map<dynamic, dynamic> values = dataSnapshot.value;
        lists.clear();
        values.forEach((key, values) {
          lists.add(values);
          print(values.toString());
          //print(values["userid"]);

          //print(values["title"]);
        });
        //activity = ActivityModel.fromSnapshot(dataSnapshot.value);
      });
    });
  }

  Future getActivitywithword(String word) async {
    String authid = authstate!.uid;
    print("method çalıştı gelen kelime" + word);
    return await databaseRef

        //child olarak yazınca da oluyor activite id sini nasıl çekcem
        .child('activities')
        .once()
        .then((DataSnapshot dataSnapshot) {
      print('savpaerlövşwövlşavöclşdscvöwdlşavcöw + ${dataSnapshot.value}');
      setState(() {
        Map<dynamic, dynamic> values = dataSnapshot.value;
        lists.clear();
        values.forEach((key, values) {
          if (values['title'].contains(word)) {
            lists.add(values);

            displayError = "";
          } else {
            //bir kere daha boş olarak geldiği için else dönüyor.

            displayError =
                "SONUÇ BULUNAMADI. Lütfen doğru arama yaptığınızdan emin olunuz.";
          }

          //print(lists);
          print(values["userid"]);
          //displayTitle = values['title'];
          //displayUsername=values['ownername'];
          //print("titledebug  " + displayTitle);
          //print(values["title"]);
          //displayDate = values['date'];
          //displayMaxpeople = values['maxPeople'];
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
       elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        title: Text(
          'Aktivite Arama',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
          // Padding(
          //   padding: EdgeInsets.only(right: 10.0),
          //   child: ElevatedButton(
          //     onPressed: () {
          //       Navigator.pop(context);
          //     },
          //     style: ElevatedButton.styleFrom(
          //         primary: Colors.purple[400],
          //         minimumSize: Size(35.0, 40.0),
          //         shape: new RoundedRectangleBorder(
          //             borderRadius: new BorderRadius.circular(30.0))),
          //     child: Text('Geri Dön'),
          //   ),
          // ),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              icon: Icon(Icons.portrait_rounded))
        ],
      ),
      body: Container(height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),),
        child: Column(
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
                                lists[index]["title"] +
                                "\nTarih: " +
                                lists[index]["date"] +
                                "\nKişi sayısı: " +
                                lists[index]["maxPeople"] +
                                "\nAktivite Sahibi: " +
                                lists[index]["ownername"]),
                            trailing: Icon(Icons.local_activity),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     //deneme();
            //     getActivity();
            //   },
            //   style: ElevatedButton.styleFrom(
            //       primary: Colors.redAccent,
            //       minimumSize: Size(85.0, 40.0),
            //       shape: new RoundedRectangleBorder(
            //           borderRadius: new BorderRadius.circular(50.0))),
            //   child: Text('Aktivite listele'),
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.of(context).push(_createRouteCreateActivity());
            //   },
            //   style: ElevatedButton.styleFrom(
            //       primary: Colors.orange[800],
            //       minimumSize: Size(85.0, 40.0),
            //       shape: new RoundedRectangleBorder(
            //           borderRadius: new BorderRadius.circular(50.0))),
            //   child: Text('Yeni Aktivite Oluştur'),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: Bottom(),
    );
  }
}
