import 'package:budgetor/helpers/objectbox_helper.dart';
import 'package:budgetor/main.dart';
import 'package:budgetor/models/user_model.dart';
import 'package:budgetor/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthHelper {
  FirebaseAuthHelper._();

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

  static Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      User? currentUser = FirebaseAuth.instance.currentUser;
      Boxes.userBox.put(
        UserModel(
          name: currentUser?.displayName ?? '',
          email: currentUser?.email ?? '',
          profileImgUrl: currentUser?.photoURL ?? '',
        ),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      logger.e('Error signing out: $e');
    }
  }
}
