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
import 'package:housey/components/widgets/BottomNavBar.dart';
import 'home_screen.dart';
import 'main_page.dart';

class EditActivity extends StatefulWidget {
  const EditActivity({Key? key}) : super(key: key);

  @override
  State<EditActivity> createState() => _EditActivityState();
}

class _EditActivityState extends State<EditActivity> {
  final textcontroller = TextEditingController();
  var titlecontroller = TextEditingController();
  var datecontroller = TextEditingController();
  var maxpeople = TextEditingController();
  var locationcontroller = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.reference();
  final authstate = FirebaseAuth.instance.currentUser;
  ActivityModel activity = ActivityModel();
  String? userDisplayName = FirebaseAuth.instance.currentUser?.email.toString();
  String delimiter = '/@';

  final activityIdRandom = DateTime.now().toString();
  List<Map<dynamic, dynamic>> lists = [];
  late ActivityModel activityData;
  _initializeControllers() {
    activityData = ModalRoute.of(context)!.settings.arguments as ActivityModel;

    titlecontroller =
        TextEditingController(text: activityData.title.toString());
    datecontroller = TextEditingController(text: activityData.date.toString());
    maxpeople = TextEditingController(text: activityData.maxPeople.toString());
    locationcontroller =
        TextEditingController(text: activityData.location.toString());
  }

  final Future<FirebaseApp> _future = Firebase.initializeApp();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeControllers();
  }

  Future updateActivity(String ownerid, String ownername, String activityid,
      String title, String date, String maxpeople, String location) async {
    ActivityModel activityModel = ActivityModel(
        ownerid: ownerid,
        ownername: ownername,
        activityid: activityid,
        title: title,
        date: date,
        maxPeople: maxpeople,
        location: location);
    try {
      databaseRef.child('activities').update(activityModel.toMap()).then(
          (ownerid) => {Fluttertoast.showToast(msg: 'Aktivite düzenlendi.')});
    } catch (e) {
      Fluttertoast.showToast(msg: 'Hata! Aktivite oluşturulamadı.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final titlefield = TextFormField(
      controller: titlecontroller,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return ("Bu alanı boş bırakmazsınız");
        }
        return null;
      },
      onSaved: (value) {
        titlecontroller.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.title),
        contentPadding: EdgeInsets.all(20),
        hintText: "Başlık",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    final datefield = TextFormField(
      controller: datecontroller,
      keyboardType: TextInputType.datetime,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Bu alanı boş bırakmazsınız");
        }
        return null;
      },
      onSaved: (value) {
        datecontroller.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.date_range),
        contentPadding: EdgeInsets.all(20),
        hintText: "Tarih",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    final maxpeoplefield = TextFormField(
      controller: maxpeople,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Bu alanı boş bırakmazsınız");
        }
        return null;
      },
      onSaved: (value) {
        maxpeople.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.people),
        contentPadding: EdgeInsets.all(20),
        hintText: "Kişi sayısı",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    final locationfield = TextFormField(
      controller: locationcontroller,
      keyboardType: TextInputType.streetAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Bu alanı boş bırakmazsınız");
        }
        return null;
      },
      onSaved: (value) {
        locationcontroller.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.location_city),
        contentPadding: EdgeInsets.all(20),
        hintText: "Aktivitenin yer alacağı konum",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    final activityAddButton = (Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(50),
      color: Colors.deepPurpleAccent[400],
      child: MaterialButton(
        padding: EdgeInsets.all(20.0),
        minWidth: MediaQuery.of(context).size.width,
        height: 30.0,
        onPressed: () {
          updateActivity(
              authstate!.uid,
              userDisplayName!,
              activityIdRandom,
              titlecontroller.text,
              datecontroller.text,
              maxpeople.text,
              locationcontroller.text);
        },
        child: Text("Aktivite Düzenle",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: const Color(0xFF527DAA),
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              fontFamily: 'OpenSans',
            )),
      ),
    ));
    return Scaffold(
      //backgroundColor: Colors.deepPurple[200],
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        automaticallyImplyLeading: false,
        title: Text('Aktivite düzenleme ekranı'),
        // actions: <Widget>[
        //   IconButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     icon: Icon(Icons.home),
        //   ),
        // ],
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
        child: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 50.0),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: titlefield,
                      ),
                      Padding(padding: EdgeInsets.all(15.0), child: datefield),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: maxpeoplefield,
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: locationfield,
                      ),
                      Center(child: activityAddButton),
                    ],
                  ),
                );
              }
            }),
      ),
      bottomNavigationBar: Bottom(),
    );
  }
}
