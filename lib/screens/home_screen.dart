import 'package:budgetor/helpers/firebase_auth_helper.dart';
import 'package:budgetor/helpers/local_notification_helper.dart';
import 'package:budgetor/helpers/shared_prefs_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      bool isFirebaseInited = SharedPrefsHelper.isFirebaseInited();
      if (isFirebaseInited) FirebaseAuthHelper.initListener(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image(
                  image: NetworkImage(FirebaseAuth.instance.currentUser?.photoURL ?? ""),
                ),
              ),
            ),
            Text(FirebaseAuth.instance.currentUser?.displayName ?? ''),
            ElevatedButton(
              onPressed: () async {
                FirebaseAuthHelper.signOut();
              },
              child: const Text('Signout', style: TextStyle(fontSize: 14)),
            ),
            ElevatedButton(
              onPressed: () async {
                bool isSuccess = await LocalNotificationHelper.showSimpleNotif(
                  id: 0,
                  title: "Notif title",
                  body: "Notif body",
                );

                if (!isSuccess && context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please Enable Notification Permissions')));
              },
              child: const Text('show Notification', style: TextStyle(fontSize: 14)),
            ),
            ElevatedButton(
              onPressed: () async {
                bool isSuccess = await LocalNotificationHelper.showScheduledNotif(
                  id: 0,
                  title: "Notif title",
                  body: "Notif body",
                  duration: const Duration(seconds: 5),
                );
                if (!isSuccess && context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please Enable Notification Permissions')));
              },
              child: const Text('Schedule Notification', style: TextStyle(fontSize: 14)),
            ),
            ElevatedButton(
              onPressed: () async {
                bool isSuccess = await LocalNotificationHelper.showPeriodicNotif(
                  id: 0,
                  title: "Notif title",
                  body: "Notif body",
                  duration: const Duration(seconds: 5),
                );
                if (!isSuccess && context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please Enable Notification Permissions')));
              },
              child: const Text('Show Periodic Notification', style: TextStyle(fontSize: 14)),
            ),
            ElevatedButton(
              onPressed: () {
                LocalNotificationHelper.cancelAllNotif();
              },
              child: const Text('Cancel All Notification', style: TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }
}
