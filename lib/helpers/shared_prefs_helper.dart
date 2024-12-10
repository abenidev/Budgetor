import 'package:budgetor/constants/shared_prefs_consts.dart';
import 'package:nb_utils/nb_utils.dart';

class SharedPrefsHelper {
  SharedPrefsHelper._();

  // isIntroShown
  static Future<bool> setIsIntroShown(bool newVal) async {
    return await setValue(kIsIntroShownKey, newVal);
  }

  static bool isIntroShown() {
    return getBoolAsync(kIsIntroShownKey, defaultValue: false);
  }

  //isFirebaseInited
  static Future<bool> setIsFirebaseInited(bool newVal) async {
    return await setValue(kIsFirebaseInited, newVal);
  }

  static bool isFirebaseInited() {
    return getBoolAsync(kIsFirebaseInited, defaultValue: false);
  }
}
