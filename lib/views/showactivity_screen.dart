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
  List<ActivityModel> activities = [];
  List<ActivityModel> activitiessearch = [];

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

  Future<List<ActivityModel>> retrieveActivities() async {
    final List<ActivityModel> result = [];
    final Query query = databaseRef.child('activities').limitToLast(50);
    query.onChildAdded.forEach((event) {
      result.add(ActivityModel.fromMap(event.snapshot.value));
    });

    return await query.once().then((ignored) => result);
  }

  Future<void> handleActListData(String a) async {
    activities = await retrieveActivities();
    //print(activities[5].toString());
    activitiessearch.clear();
    for (int i = 0; i < activities.length; i++) {
      if (activities[i]
          .title
          .toString()
          .toLowerCase()
          .contains(a.toLowerCase())) {
        activitiessearch.add(activities[i]);
      }
    }

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
    List<String> b = [participantId];
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
        databaseRef
            .child('activities')
            .child(key)
            .update(activityModel.toMap())
            .then((ownerid) => {
                  Fluttertoast.showToast(msg: 'Aktiviteye başarıyla katıldınız')
                });
        setState(() {
          
        });

       
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        title: Text(
          'Aktivite Arama',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                          handleActListData(value);
                        },
                      ),
                    ),
                    InkWell(
                      child: Icon(
                        Icons.security_rounded,
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
         
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              icon: Icon(Icons.portrait_rounded))
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
              Color(0xFFCA3782),
              Color(0xFF1E0B36),
            ],
            stops: [0.1, 0.9],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: activitiessearch.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Colors.transparent,
                      child: Column(
                        
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            tileColor: Color(0xFF232946),
                            onTap: () {},
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            leading: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: new BoxDecoration(
                                //borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
                                  border: new Border(
                                      right: new BorderSide(
                                          width: 2.5, color: Colors.white24))),
                              child: Icon(Icons.people_alt_outlined, color: Colors.white70),
                            ),
                            title: Text(
                              "Başlık: " +
                                  activitiessearch[index].title.toString() +
                                  "\nTarih: " +
                                  activitiessearch[index].date.toString() +
                                  "\nKişi sayısı: " +
                                  activitiessearch[index].maxPeople.toString() +
                                  "\nAktivite Sahibi: " +
                                  activitiessearch[index].ownername.toString(),
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
      bottomNavigationBar: Bottom(),
    );
  }
}
