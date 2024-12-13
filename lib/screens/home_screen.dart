import 'package:budgetor/helpers/firebase_auth_helper.dart';
import 'package:budgetor/helpers/shared_prefs_helper.dart';
import 'package:budgetor/helpers/workmanager_helper.dart';
import 'package:budgetor/screens/setting_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

      //register workmanager task
      WorkmanagerHelper.registerDemoTask();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.w,
                    backgroundColor: Theme.of(context).canvasColor,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image(
                        image: NetworkImage(FirebaseAuth.instance.currentUser?.photoURL ?? ""),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, ${FirebaseAuth.instance.currentUser?.displayName ?? ''}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        'Monthly Budget',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => const SettingScreen()));
                    },
                    icon: Icon(Icons.settings, size: 22.w),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
