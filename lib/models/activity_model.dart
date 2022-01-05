import 'user_model.dart';
import 'package:firebase_database/firebase_database.dart';

class ActivityModel {
  String? id;
  String? title;
  DateTime? date;
  String? maxPeople;
  String? location;
  //UserModel? activityOwner;

  ActivityModel(
      {this.id, this.title, this.date, this.maxPeople, this.location});

  ActivityModel.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    title = snapshot.value['title'];
    date = snapshot.value['date'];
    maxPeople = snapshot.value['maxPeople'];
    location = snapshot.value['location'];
  }
  factory ActivityModel.fromMap(map) {
    return ActivityModel(
      id: map['id'],
      title: map['title'],
      date: map['date'],
      maxPeople: map['maxPeople'],
      location: map['location'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tilte': title,
      'date': date,
      'maxPeople': maxPeople,
      'location': location,
    };
  }
}
