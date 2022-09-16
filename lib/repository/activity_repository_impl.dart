import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:housey/models/activity_model.dart';
import 'package:housey/repository/activity_repository.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final databaseRef = FirebaseDatabase.instance.reference();
  final authstate = FirebaseAuth.instance.currentUser;
  @override
  Future<List<ActivityModel>> retrieveActivities() async {
    final List<ActivityModel> result = [];

    final Query query = databaseRef.child('activities').limitToLast(4);
    query.onChildAdded.forEach((event) {
      result.add(ActivityModel.fromMap(event.snapshot.value));
    });

    return await query.once().then((ignored) => result);
  }

  @override
  Future addActivityToDatabase(
      String ownerid,
      String ownername,
      String activityid,
      String title,
      String date,
      String maxpeople,
      String location) async {
    List<String> participantList = [""];
    ActivityModel activityModel = ActivityModel(
        ownerid: ownerid,
        ownername: ownername,
        activityid: activityid,
        title: title,
        date: date,
        maxPeople: maxpeople,
        location: location,
        participantList: participantList);

    if (title != "" && date != "" && maxpeople != "" && location != "") {
      databaseRef.child('activities').push().set(activityModel.toMap()).then(
          (ownerid) => {Fluttertoast.showToast(msg: 'Aktivite oluşturuldu.')});
    } else {
      Fluttertoast.showToast(
          msg:
              'Aktivite oluşturulamadı. Lütfen boş alanları doldurup tekrar deneyiniz.');
    }
  }
}
