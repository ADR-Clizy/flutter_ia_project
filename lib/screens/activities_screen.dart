import 'package:app_projet/models/activity.dart';
import 'package:app_projet/screens/activity_details_screen.dart';
import 'package:app_projet/screens/add_activity_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_projet/api/activities_api.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple,
        title: const Text("Activités"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const AddActivityScreen();
                  },
                ),
              );
            },
          )
        ],
      ),
      body: FutureBuilder<List<Activity>>(
        future: getActivities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Divider(
                        color: Colors.black,
                      )),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Activity activity = snapshot.data![index];
                    return Row(children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Hero(
                        tag: 'activityImage${activity.title}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            activity.preview,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                activity.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.purple,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 17,
                                  color: Colors.purple,
                                ),
                                const SizedBox(width: 5),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    activity.place,
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.euro_rounded,
                                  size: 17,
                                  color: Colors.purple,
                                ),
                                const SizedBox(width: 5),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    activity.price.toString(),
                                    style: const TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return Builder(
                                  builder: (context) {
                                    return ActivityDetails(activity: activity);
                                  },
                                );
                              },
                            ),
                          );
                        },
                      )
                    ]);
                  },
                ));
          } else {
            return const Center(child: Text('Aucune activité trouvée'));
          }
        },
      ),
    );
  }
}
