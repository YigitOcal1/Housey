
import 'package:housey/models/activity_model.dart';

abstract class ActivityRepository{

  Future<List<ActivityModel>> retrieveActivities();

  Future addActivityToDatabase(String ownerid, String ownername, String activityid,
      String title, String date, String maxpeople, String location);
}