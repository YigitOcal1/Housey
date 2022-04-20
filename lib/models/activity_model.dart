import 'user_model.dart';
import 'package:firebase_database/firebase_database.dart';

class ActivityModel {
  String? ownerid;
  String? activityid;
  String? title;
  String? date;
  String? maxPeople;
  String? location;
  //UserModel? activityOwner;

  ActivityModel(
      {this.ownerid,
      this.activityid,
      this.title,
      this.date,
      this.maxPeople,
      this.location});

  ActivityModel.fromSnapshot(DataSnapshot snapshot) {
    ownerid = snapshot.value['ownerid'];
    activityid = snapshot.key;
    title = snapshot.value['title'];
    date = snapshot.value['date'];
    maxPeople = snapshot.value['maxPeople'];
    location = snapshot.value['location'];
  }
  factory ActivityModel.fromMap(map) {
    return ActivityModel(
      ownerid: map['ownerid'],
      activityid: map['activityid'],
      title: map['title'],
      date: map['date'],
      maxPeople: map['maxPeople'],
      location: map['location'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'ownerid': ownerid,
      'activityid': activityid,
      'title': title,
      'date': date,
      'maxPeople': maxPeople,
      'location': location,
    };
  }
}
