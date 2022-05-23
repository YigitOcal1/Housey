import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:housey/models/activity_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:housey/widgets/BottomNavBar.dart';
import 'showactivity_screen.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final textcontroller = TextEditingController();
  final title_controller = TextEditingController();
  final date_controller = TextEditingController();
  final maxpeople_controller = TextEditingController();
  final location_controller = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.reference();
  final authstate = FirebaseAuth.instance.currentUser;
  String? userDisplayName = FirebaseAuth.instance.currentUser?.email.toString();
  String delimiter = '/@';

  final activityIdRandom = DateTime.now().toString();
  final Future<FirebaseApp> _future = Firebase.initializeApp();

  Future addData(String ownerid, String ownername, String activityid,
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
      databaseRef.child('activities').push().set(activityModel.toMap()).then(
          (ownerid) => {Fluttertoast.showToast(msg: 'Aktivite oluşturuldu.')});
    } catch (e) {
      Fluttertoast.showToast(msg: 'Hata! Aktivite oluşturulamadı.');
    }
  }

  void printFirebase() {
    databaseRef.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
      print("USER ADI     " + authstate!.email.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final titlefield = TextFormField(
      controller: title_controller,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return ("Bu alanı boş bırakmazsınız");
        }
        return null;
      },
      onSaved: (value) {
        title_controller.text = value!;
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
      controller: date_controller,
      keyboardType: TextInputType.datetime,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Bu alanı boş bırakmazsınız");
        }
        return null;
      },
      onSaved: (value) {
        title_controller.text = value!;
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
      controller: maxpeople_controller,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Bu alanı boş bırakmazsınız");
        }
        return null;
      },
      onSaved: (value) {
        title_controller.text = value!;
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
      controller: location_controller,
      keyboardType: TextInputType.streetAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Bu alanı boş bırakmazsınız");
        }
        return null;
      },
      onSaved: (value) {
        title_controller.text = value!;
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
          addData(
              authstate!.uid,
              userDisplayName!,
              activityIdRandom,
              title_controller.text,
              date_controller.text,
              maxpeople_controller.text,
              location_controller.text);
        },
        child: Text(
          "Aktivite Oluştur",
          
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20,   color: const Color(0xFF527DAA), fontWeight: FontWeight.bold,letterSpacing: 2,fontFamily: 'OpenSans',)
        ),
      ),
    ));
    //printFirebase();
    return Scaffold(
      //backgroundColor: Colors.deepPurple[200],
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        automaticallyImplyLeading: false,
        title: Text('Aktivite ekleme ekranı'),
        // actions: <Widget>[
        //   IconButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     icon: Icon(Icons.home),
        //   ),
        // ],
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
