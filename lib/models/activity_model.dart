import 'user_model.dart';

class ActivityModel {
  String? id;
  String? title;
  DateTime? date;
  int? maxPeople;
  String? location;
  UserModel? activityOwner;

  ActivityModel(
      {this.id,
      this.title,
      this.date,
      this.maxPeople,
      this.location,
      this.activityOwner});

  factory ActivityModel.fromMap(map) {
    return ActivityModel(
      id: map['id'],
      title: map['title'],
      date: map['date'],
      maxPeople: map['maxPeople'],
      location: map['location'],
      activityOwner: map['activityOwner'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tilte': title,
      'date': date,
      'maxPeople': maxPeople,
      'location': location,
      'activityOwner': activityOwner,
    };
  }
}
