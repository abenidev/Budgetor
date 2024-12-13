import 'package:budgetor/helpers/firebase_auth_helper.dart';
import 'package:budgetor/helpers/local_notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting', style: TextStyle(fontSize: 16.sp)),
      ),
      body: Column(
        children: [
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
    );
  }
}
