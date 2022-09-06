import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:housey/models/activity_model.dart';
import 'package:housey/models/user_model.dart';

class FirebaseRepository {
  final databaseRef = FirebaseDatabase.instance.reference();
  final authstate = FirebaseAuth.instance.currentUser;

  Future addParticipant(
      ActivityModel activityModel, List<String> participantList) async {
    return await databaseRef
        .child('activities')
        .orderByChild('title')
        .equalTo(activityModel.title)
        .once()
        .then((DataSnapshot dataSnapshot) {
      Map<dynamic, dynamic> values = dataSnapshot.value;
      values.forEach((key, value) {
        if (activityModel.ownerid != authstate!.uid) {
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
      });
    });
  }

  Future<List<ActivityModel>> retrieveActivities() async {
    final List<ActivityModel> result = [];
    final Query query = databaseRef.child('activities').limitToLast(4);
    query.onChildAdded.forEach((event) {
      result.add(ActivityModel.fromMap(event.snapshot.value));
    });

    return await query.once().then((ignored) => result);
  }

  Future updateActivity(ActivityModel activityModel) async {
    try {
      databaseRef.child('activities').update(activityModel.toMap()).then(
          (ownerid) => {Fluttertoast.showToast(msg: 'Aktivite düzenlendi.')});
    } catch (e) {
      Fluttertoast.showToast(msg: 'Hata! Aktivite oluşturulamadı.');
    }
  }

  Future addActivity(ActivityModel activityModel) async {
    List<String> b = [""];
    try {
      databaseRef.child('activities').push().set(activityModel.toMap()).then(
          (ownerid) => {Fluttertoast.showToast(msg: 'Aktivite oluşturuldu.')});
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              'Aktivite oluşturulamadı. Lütfen boş alanları doldurup tekrar deneyiniz.');
    }
  }
}
