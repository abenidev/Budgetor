import 'package:budgetor/helpers/firebase_auth_helper.dart';
import 'package:budgetor/main.dart';
import 'package:budgetor/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            UserCredential userCredential = await FirebaseAuthHelper.signInWithGoogle();
            logger.i(userCredential);

            if (FirebaseAuth.instance.currentUser != null && context.mounted) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
            }
          },
          child: Text(
            'Signin with Google',
            style: TextStyle(fontSize: 12.sp),
          ),
        ),
      ),
    );
  }
}
