import 'package:budgetor/firebase_options.dart';
import 'package:budgetor/helpers/firebase_messaging.dart';
import 'package:budgetor/helpers/shared_prefs_helper.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class FirebaseHelper {
  FirebaseHelper._();

  static Future<void> initFirebase() async {
    //firebase
    bool isFirebaseInited = SharedPrefsHelper.isFirebaseInited();
    if (!isFirebaseInited) {
      bool hasInternet = await InternetConnection().hasInternetAccess;
      if (hasInternet) {
        await _initialize();
        await SharedPrefsHelper.setIsFirebaseInited(true);
      }
    } else {
      await _initialize();
    }
  }

  static Future<void> _initialize() async {
    debugPrint('Initializing firebase -----------------');
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(kReleaseMode);

      if (kReleaseMode) {
        //crashlytics
        FlutterError.onError = (errorDetails) {
          FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
        };
        // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
        PlatformDispatcher.instance.onError = (error, stack) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true;
        };
      }

      //messaging
      await FirebaseMessagingApi().initNotifications();
    } catch (e) {
      debugPrint('error in initFirebase: ${e}');
    }
  }

  static Future<void> logAnalyticsEvent({required String eventName, Map<String, Object>? parameters}) async {
    debugPrint('eventName: ${eventName} || parameters: ${parameters}');

    if (kReleaseMode) {
      bool isFirebaseInited = SharedPrefsHelper.isFirebaseInited();
      if (isFirebaseInited) {
        final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
        analytics.setAnalyticsCollectionEnabled(true);
        debugPrint('------------------- logging to analytics...');
        await analytics.logEvent(
          name: eventName,
          parameters: parameters,
        );
      }
    }
  }

  //
}
