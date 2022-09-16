import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:housey/models/activity_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:housey/components/widgets/BottomNavBar.dart';
import 'package:housey/utils/constants.dart';
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
    //List<String> a=["w","w"];
    List<String> b = [""];
    ActivityModel activityModel = ActivityModel(
        ownerid: ownerid,
        ownername: ownername,
        activityid: activityid,
        title: title,
        date: date,
        maxPeople: maxpeople,
        location: location,
        participantList: b);

    if (title != "" && date != "" && maxpeople != "" && location != "") {
      databaseRef.child('activities').push().set(activityModel.toMap()).then(
          (ownerid) => {Fluttertoast.showToast(msg: 'Aktivite oluşturuldu.')});
    } else {
      Fluttertoast.showToast(
          msg:
              'Aktivite oluşturulamadı. Lütfen boş alanları doldurup tekrar deneyiniz.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final titlefield = TextFormField(
      controller: title_controller,
      keyboardType: TextInputType.text,
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'OpenSans',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return ("Başlık alanı boş bırakılamaz");
        }
      },
      onSaved: (value) {
        title_controller.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.title),
        contentPadding: EdgeInsets.all(20),
        hintText: "Başlık",
        hintStyle: TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    final datefield = TextFormField(
      controller: date_controller,
      keyboardType: TextInputType.datetime,
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'OpenSans',
      ),
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
        hintStyle: TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    final maxpeoplefield = TextFormField(
      controller: maxpeople_controller,
      keyboardType: TextInputType.number,
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'OpenSans',
      ),
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
        hintStyle: TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    final locationfield = TextFormField(
      controller: location_controller,
      keyboardType: TextInputType.streetAddress,
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'OpenSans',
      ),
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
        hintStyle: TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    final activityAddButton = (Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(25.0),
      color: Color(0xFF232946),
      child: MaterialButton(
        padding: EdgeInsets.all(20.0),
        minWidth: MediaQuery.of(context).size.width,
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
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    ));
    //printFirebase();
    return Scaffold(
      //backgroundColor: Colors.deepPurple[200],
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: SafeArea(
          child: AppBar(
            elevation: 1,
            title: Text(
              'Aktivite Ekleme',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            flexibleSpace: Constants().flexibleSpaceContainer,
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: <Widget>[],
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: Constants().boxDecorationApp,
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
