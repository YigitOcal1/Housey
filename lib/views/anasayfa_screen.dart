import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:housey/models/activity_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:housey/views/home_screen.dart';
import 'package:housey/views/main_page.dart';
import 'profile_screen.dart';
import 'package:housey/widgets/BottomNavBar.dart';

class AnasayfaScreen extends StatefulWidget {
  const AnasayfaScreen({Key? key}) : super(key: key);
  @override
  _AnasayfaScreenState createState() => _AnasayfaScreenState();
}

class _AnasayfaScreenState extends State<AnasayfaScreen> {
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getActivity();
  }

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

  Future getActivity() async {
    await databaseRef
        .child('activities')
        .limitToLast(3)
        .once()
        .then((DataSnapshot dataSnapshot) {
      Map<dynamic, dynamic> values = dataSnapshot.value;
      lists.clear();
      values.forEach((key, values) {
        lists.add(values);

        print(values.toString());
        setState(() {
          isLoading = false;
        });
        //activity = ActivityModel.fromSnapshot(dataSnapshot.value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        appBar: AppBar(
          elevation: 0.1,
          backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          //elevation: 5.0,
          //backgroundColor: (Colors.deepPurple),
          title: Text(
            'Ana Sayfa',
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
        body: Container(
          height: double.infinity,
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
              
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Text(
                  'Sizin için önerilen aktiviteler',
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
                    itemCount: lists.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              // onTap: () {
                              //   setState(() {
                              //     print("tıklama çalışıyor");
                              //   });
                              // },
                              tileColor:Color.fromRGBO(58, 66, 86, 1.0) ,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0, color: Colors.white24))),
                                child: Icon(Icons.party_mode, color: Colors.white),
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
                            //Text("Başlık: " + lists[index]["title"]),
                            //Text("Tarih: " + lists[index]["date"]),
                            //Text("Kişi sayısı: " + lists[index]["maxPeople"]),
                            //Text("Aktivite sahibi: " + lists[index]["ownername"]),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Bottom());
  }
}
