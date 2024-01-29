import 'package:app_projet/models/activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Activity>> getActivities() async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('activities').get();

  return snapshot.docs
      .map((doc) => Activity.fromMap(doc.data() as Map<String, dynamic>))
      .toList();
}
