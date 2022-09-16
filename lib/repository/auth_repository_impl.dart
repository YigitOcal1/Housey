import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:housey/components/widgets/RoutesAnimations.dart';
import 'package:housey/models/user_model.dart';
import 'package:housey/views/register_screen.dart';

import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final _auth = FirebaseAuth.instance;
  final databaseRef = FirebaseDatabase.instance.reference();
  final authstate = FirebaseAuth.instance.currentUser;

  @override
  void logIn(String email, String password) async {
    String? errormsg;
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                Fluttertoast.showToast(msg: 'Giriş Başarılı'),
              });
    } on FirebaseAuthException catch (error) {
      errormsg = "Giriş başarısız";
    }
    Fluttertoast.showToast(msg: errormsg!);
  }

  @override
  void register(String email, String password) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel usermodel = UserModel();

    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async => {
                usermodel.email = user!.email,
                usermodel.uid = user.uid,
                usermodel.username = user.email!.replaceAll("@gmail.com", ""),
                await firestore
                    .collection("users")
                    .doc(user.uid)
                    .set(usermodel.toMap()),
                Fluttertoast.showToast(msg: "Hesap oluşturuldu")
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: 'Hata! Hesap oluşturulamadı.');
      });
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(msg: 'Kayıt işlemi başarısız.');
    }
  }

  @override
  Future addUserToDatabase(
      String username, String email, String password) async {
    if (email != "") {
      final UserModel usermodel =
          UserModel(email: email, password: password, username: username);
      try {
        databaseRef
            .child('users')
            .push()
            .set(usermodel.toMap())
            .then((uid) => {Fluttertoast.showToast(msg: 'Hesap oluşturuldu.')});
      } catch (e) {
        Fluttertoast.showToast(msg: 'Hata! Hesap oluşturulamadı.');
      }
    } else {
      Fluttertoast.showToast(msg: 'Hata! Hesap oluşturulamadı.');
    }
  }
}
