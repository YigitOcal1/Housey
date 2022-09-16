import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:housey/components/widgets/RoutesAnimations.dart';
import 'package:housey/models/activity_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:housey/views/home_screen.dart';
import 'package:housey/views/create_activity_screen.dart';
import 'profile_screen.dart';
import 'package:housey/components/widgets/BottomNavBar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final textcontroller = TextEditingController();
  final titlecontroller = TextEditingController();
  final datecontroller = TextEditingController();
  final maxpeople = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.reference();
  final authstate = FirebaseAuth.instance.currentUser;
  ActivityModel activity = ActivityModel();
  List<Map<dynamic, dynamic>> lists = [];
  List<ActivityModel> activities = [];

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
  List<String> b = [];

  @override
  void initState() {
    super.initState();
    //getActivity();
    handleActListData();
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).push(RouteAnimations().createRouteCreateHomePage());
  }

  Future<List<ActivityModel>> retrieveActivities() async {
    final List<ActivityModel> result = [];
    final Query query = databaseRef.child('activities').limitToLast(4);
    query.onChildAdded.forEach((event) {
      result.add(ActivityModel.fromMap(event.snapshot.value));
    });

    return await query.once().then((ignored) => result);
  }

  Future<void> handleActListData() async {
    activities = await retrieveActivities();
    setState(() {});
  }

  Future addParticipant(
      String ownerid,
      String ownername,
      String activityid,
      String title,
      String date,
      String maxpeople,
      String location,
      String participantId) async {
    b.add(participantId);
    ActivityModel activityModel = ActivityModel(
        ownerid: ownerid,
        ownername: ownername,
        activityid: activityid,
        title: title,
        date: date,
        maxPeople: maxpeople,
        location: location,
        participantList: b);
    return await databaseRef
        .child('activities')
        .orderByChild('title')
        .equalTo(title)
        .once()
        .then((DataSnapshot dataSnapshot) {
      Map<dynamic, dynamic> values = dataSnapshot.value;
      values.forEach((key, value) {
        if (ownerid != authstate!.uid) {
          databaseRef
              .child('activities')
              .child(key)
              .update(activityModel.toMap())
              .then((ownerid) => {
                    Fluttertoast.showToast(
                        msg: 'Aktiviteye başarıyla katıldınız')
                  });
        } else {
          Fluttertoast.showToast(
              msg: 'Kendi oluşturduğunuz aktiviteye katılmazsınız');
        }
        setState(() {
          //Navigator.of(context).push(_createRouteProfilScreen());
        });

        //activity = ActivityModel.fromSnapshot(dataSnapshot.value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        //backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: SafeArea(
            child: AppBar(
              elevation: 1,
              title: Text(
                'Ana Sayfa',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF1E0B36),
                      Color(0xFFCA3782),
                    ],
                    stops: [0.1, 0.9],
                  ),
                ),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              actions: <Widget>[
                // Padding(
                //   padding: EdgeInsets.only(right: 10.0),
                //   child: ElevatedButton(
                //     onPressed: () {
                //       logout(context);
                //     },
                //     style: ElevatedButton.styleFrom(
                //         primary: Color(0xFFEEBBC3),
                //         minimumSize: Size(35.0, 40.0),
                //         shape: new RoundedRectangleBorder(
                //             borderRadius: new BorderRadius.circular(30.0))),
                //     child: Text('Çıkış yap'),
                //   ),
                // ),
              ],
            ),
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFCA3782),
                Color(0xFF1E0B36),
              ],
              stops: [0.1, 0.9],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Text(
                  'Sizin için önerilen aktiviteler',
                  style: TextStyle(
                    fontSize: 26.0,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: activities.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              // onTap: () {
                              //   setState(() {
                              //     print("tıklama çalışıyor");
                              //   });
                              // },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              tileColor: Color(0xFF232946),
                              onTap: () {},
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 2.5,
                                            color: Colors.white24))),
                                child: Icon(
                                  Icons.people_alt_outlined,
                                  color: Colors.white70,
                                ),
                              ),
                              title: Text(
                                "Başlık: " +
                                    activities[index].title.toString() +
                                    "\nTarih: " +
                                    activities[index].date.toString() +
                                    "\nKişi sayısı: " +
                                    activities[index].maxPeople.toString() +
                                    "\nAktivite Sahibi: " +
                                    activities[index].ownername.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                              trailing: IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(activities[index]
                                                    .title
                                                    .toString() +
                                                " adlı aktiviteye katılmak istiyor musunuz."),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Hayır')),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    addParticipant(
                                                        activities[index]
                                                            .ownerid
                                                            .toString(),
                                                        activities[index]
                                                            .ownername
                                                            .toString(),
                                                        activities[index]
                                                            .activityid
                                                            .toString(),
                                                        activities[index]
                                                            .title
                                                            .toString(),
                                                        activities[index]
                                                            .date
                                                            .toString(),
                                                        activities[index]
                                                            .maxPeople
                                                            .toString(),
                                                        activities[index]
                                                            .location
                                                            .toString(),
                                                        authstate!.email
                                                            .toString());
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Evet'))
                                            ],
                                          );
                                        });
                                  },
                                  icon: Icon(Icons.play_circle_outlined,
                                      color: Colors.green[700])),
                            ),
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
