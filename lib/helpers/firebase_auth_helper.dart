import 'package:budgetor/helpers/firestore_helper.dart';
import 'package:budgetor/helpers/objectbox_helper.dart';
import 'package:budgetor/main.dart';
import 'package:budgetor/models/user_model.dart';
import 'package:budgetor/screens/home_screen.dart';
import 'package:budgetor/screens/login_screen.dart';
import 'package:budgetor/screens/user_detail_filling_screen.dart';
import 'package:budgetor/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthHelper {
  FirebaseAuthHelper._();

  static void authNavigationHandler(BuildContext context, DataFetchState dataFetchState) {
    switch (dataFetchState) {
      case DataFetchState.hasData:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
        return;
      case DataFetchState.hasNoData:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UserDetailFillingScreen()));
        return;
      case DataFetchState.failed:
        showCustomSnackBar(context, 'Couldn\'t log you in, please check your internet connection and try again!');
        return;
      default:
        throw Exception('cannot find dataFetchState: ${dataFetchState} type in authNavigationHandler(FirebaseAuthHelper.dart)');
    }
  }

  static void initListener(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (context.mounted) {
        if (user == null) {
          logger.i('User is currently signed out!');
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
        } else {
          logger.i('User is signed in!');
        }
      }
    });
  }

  static Future<DataFetchState> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        await signOut();
        return DataFetchState.failed;
      }

      //
      UserModel? userModel = await FirestoreHelper.getUserDocData();
      logger.i("userModel: $userModel");
      if (userModel == null) {
        UserModel userData = UserModel(
          name: currentUser.displayName ?? '',
          email: currentUser.email ?? '',
          profileImgUrl: currentUser.photoURL ?? '',
        );
        int id = Boxes.userBox.put(userData);
        bool isDataAdded = await FirestoreHelper.addNewUser(userData.copyWith(id: id));
        if (!isDataAdded) {
          await signOut();
          return DataFetchState.failed;
        }

        return DataFetchState.hasNoData;
      }

      DataFetchState dataFetchState = await FirestoreHelper.getUserIncomesData();
      logger.i('dataFetchState: ${dataFetchState}');
      if (dataFetchState == DataFetchState.failed) {
        await signOut();
        return DataFetchState.failed;
      } else if (dataFetchState == DataFetchState.hasNoData) {
        return DataFetchState.hasNoData;
      }

      return DataFetchState.hasData;
    } catch (e) {
      logger.e(e);
      await signOut();
      return DataFetchState.failed;
    }
  }

  static Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      Boxes.userBox.removeAll();
      Boxes.incomesBox.removeAll();
    } catch (e) {
      logger.e('Error signing out: $e');
    }
  }
}
