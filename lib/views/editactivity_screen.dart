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
import 'package:housey/widgets/BottomNavBar.dart';
import 'home_screen.dart';
import 'main_page.dart';

class EditActivity extends StatefulWidget {
  const EditActivity({Key? key}) : super(key: key);

  

  @override
  State<EditActivity> createState() => _EditActivityState();
}

class _EditActivityState extends State<EditActivity> {

  final textcontroller = TextEditingController();
  final titlecontroller = TextEditingController();
  final datecontroller = TextEditingController();
  final maxpeople = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.reference();
  final authstate = FirebaseAuth.instance.currentUser;
  ActivityModel activity = ActivityModel();
  List<Map<dynamic, dynamic>> lists = [];

  final Future<FirebaseApp> _future = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}