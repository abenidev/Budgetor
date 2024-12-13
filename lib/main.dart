import 'package:budgetor/helpers/firebase_helper.dart';
import 'package:budgetor/helpers/objectbox_helper.dart';
import 'package:budgetor/helpers/workmanager_helper.dart';
import 'package:budgetor/screens/home_screen.dart';
import 'package:budgetor/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:budgetor/constants/strings.dart';
import 'package:budgetor/helpers/local_notification_helper.dart';
import 'package:workmanager/workmanager.dart';

Logger logger = Logger();
late ObjectBox objectbox;

final isAppLoadingProvider = StateProvider<bool>((ref) {
  return false;
});

@pragma('vm:entry-point')
void callbackDispatcher() {
  WorkmanagerHelper.initExecuteTask();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //init objectbox
  objectbox = await ObjectBox.create();
  //workmanager
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  //nb_utils shared pref initialization
  await initialize();
  //initialize firebase
  await FirebaseHelper.initFirebase();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: appName,
          // ignore: deprecated_member_use
          useInheritedMediaQuery: true,
          theme: FlexColorScheme.light(scheme: FlexScheme.deepOrangeM3, useMaterial3: true, fontFamily: 'Poppins').toTheme,
          darkTheme: FlexColorScheme.dark(scheme: FlexScheme.deepOrangeM3, useMaterial3: true, fontFamily: 'Poppins').toTheme,
          themeMode: ThemeMode.system,
          home: const Root(),
        );
      },
    );
  }
}

class Root extends ConsumerStatefulWidget {
  const Root({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RootState();
}

class _RootState extends ConsumerState<Root> with TickerProviderStateMixin {
  //Anim
  late AnimationController controller;
  Tween<double> tween = Tween(begin: 0.8, end: 1);

  @override
  void initState() {
    super.initState();
    //Anim
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    controller.repeat(reverse: true);

    afterBuildCreated(() {
      _init();
    });
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  _init() async {
    //localNotif
    await LocalNotificationHelper.requestPermission();
    await LocalNotificationHelper.initializeNotif();

    if (mounted) {
      if (FirebaseAuth.instance.currentUser != null && context.mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xff803D3B) : const Color(0xff803D3B),
      body: Container(
        decoration: const BoxDecoration(),
        child: Center(
          child: ScaleTransition(
            scale: tween.animate(CurvedAnimation(parent: controller, curve: Curves.ease)),
            child: Image(
              height: 110.h,
              width: 110.w,
              image: const AssetImage('assets/icon/icon_round.png'),
            ),
          ),
        ),
      ),
    );
  }
}
