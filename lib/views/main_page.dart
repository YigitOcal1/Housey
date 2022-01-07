import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:housey/models/activity_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  final databaseRef = FirebaseDatabase.instance.reference().child('activities');
  final authstate = FirebaseAuth.instance.currentUser;
  final Future<FirebaseApp> _future = Firebase.initializeApp();

  Future addData(
    String title,
    String date,
    String maxpeople_controller,
  ) async {
    try {
      databaseRef.push().set({
        'userid': authstate!.uid,
        'title': title,
        'date': date,
        'peoplenumber': maxpeople_controller
      }).then((uid) => {Fluttertoast.showToast(msg: 'Aktivite oluşturuldu.')});
    } catch (e) {
      Fluttertoast.showToast(msg: 'Hata! Aktivite oluşturulamadı.');
    }
  }

  void printFirebase() {
    databaseRef.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final titlefield = TextFormField(
      controller: title_controller,
      keyboardType: TextInputType.text,
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
        prefixIcon: Icon(Icons.title),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
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
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
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
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
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
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Aktivitenin yer alacağı konum",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    final activityAddButton = (Material(
      elevation: 30,
      borderRadius: BorderRadius.circular(50),
      color: Colors.deepPurpleAccent[400],
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        height: 40.0,
        onPressed: () {
          addData(title_controller.text, date_controller.text,
              maxpeople_controller.text);
        },
        child: Text(
          "Aktivite Oluştur",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    ));
    //printFirebase();
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: (Colors.deepPurple[600]),
        automaticallyImplyLeading: false,
        title: Text('Aktivite ekleme ekranı'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.home),
          ),
        ],
      ),
      body: FutureBuilder(
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
                    Padding(
                      padding: EdgeInsets.only(top: 40.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowActivity()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.redAccent,
                            minimumSize: Size(85.0, 40.0),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(50.0))),
                        child: Text('Aktivite listele'),
                      ),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }
}
