import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:housey/repository/activity_repository_impl.dart';

import '../models/activity_model.dart';
import '../repository/auth_repository_impl.dart';

class ProfileViewModel extends ChangeNotifier {
  final _authRepository = AuthRepositoryImpl();
  final _activityRepository = ActivityRepositoryImpl();
  final authstate = FirebaseAuth.instance.currentUser;
  final authEmail = FirebaseAuth.instance.currentUser!.email;
  List<ActivityModel> activities = [];
  List<ActivityModel> activitiesowner = [];
  List<ActivityModel> activitiesjoined = [];
  Future<void> logOut() async {
    _authRepository.logOut();
  }

  Future<List<ActivityModel>> fetchUserActivities() async {
    activities =
        _activityRepository.retrieveActivities() as List<ActivityModel>;
    return activities;
  }

  Future<void> handleActListData() async {
    activities = await fetchUserActivities();
    //print(activities[5].toString());
    for (int i = 0; i < activities.length; i++) {
      if (activities[i].ownername == authEmail) {
        activitiesowner.add(activities[i]);
      }
    }
  }

  Future<void> handleJoinedActListData() async {
    activities = await fetchUserActivities();
    for (int i = 0; i < activities.length; i++) {
      if (activities[i].participantList!.contains(authEmail)) {
        activitiesjoined.add(activities[i]);
      }
    }
  }
}
