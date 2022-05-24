import 'user_model.dart';
import 'package:firebase_database/firebase_database.dart';

class ActivityModel {
  String? ownerid;
  String? ownername;
  String? activityid;
  String? title;
  String? date;
  String? maxPeople;
  String? location;
  List<String>? participantList;
  //UserModel? activityOwner;

  ActivityModel(
      {this.ownerid,
      this.ownername,
      this.activityid,
      this.title,
      this.date,
      this.maxPeople,
      this.location,
      this.participantList});

 factory ActivityModel.fromSnapshot(DataSnapshot snapshot) {
  
    return ActivityModel(
    ownerid: snapshot.value['ownerid'],
    ownername: snapshot.value['ownername'],
    activityid :snapshot.value['activityid'],
    title :snapshot.value['title'],
    date : snapshot.value['date'],
    maxPeople : snapshot.value['maxPeople'],
    location : snapshot.value['location'],
    participantList: snapshot.value['participantList']);
    
  }
  factory ActivityModel.fromMap(map) {
    return ActivityModel(
      ownerid: map['ownerid'],
      ownername: map['ownername'],
      activityid: map['activityid'],
      title: map['title'],
      date: map['date'],
      maxPeople: map['maxPeople'],
      location: map['location'],
      participantList: List<String>.from(map['participantList'])
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'ownerid': ownerid,
      'ownername':ownername,
      'activityid': activityid,
      'title': title,
      'date': date,
      'maxPeople': maxPeople,
      'location': location,
      'participantList':List<dynamic>.from(participantList!)
    };
  }
}
