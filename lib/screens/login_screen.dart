import 'package:budgetor/helpers/firebase_auth_helper.dart';
import 'package:budgetor/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:sign_in_button/sign_in_button.dart';

final isSignInBtnLoadingProvider = StateProvider<bool>((ref) {
  return false;
});

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    bool isSignInBtnLoading = ref.watch(isSignInBtnLoadingProvider);

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              RichText(
                text: TextSpan(
                  text: '',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 26.sp),
                  children: const <TextSpan>[
                    TextSpan(text: 'Take Control ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: 'of your finance Today!'),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              SizedBox(
                width: 310.w,
                height: 300.h,
                child: Lottie.asset('assets/anims/bar_chart_1.json'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Get a clear picture of where your money is going to make it easier to save for what truly matters. No need to be a finance expert. The app does the math for you!',
                  style: TextStyle(fontSize: 12.sp),
                ),
              ),
              SizedBox(height: 10.h),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: SignInButton(
                      Buttons.google,
                      mini: false,
                      elevation: isSignInBtnLoading ? 0.0 : 2.0,
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      onPressed: () async {
                        if (isSignInBtnLoading) return;
                        ref.read(isSignInBtnLoadingProvider.notifier).state = true;
                        bool isSignedIn = await FirebaseAuthHelper.signInWithGoogle();
                        ref.read(isSignInBtnLoadingProvider.notifier).state = false;
                        if (FirebaseAuth.instance.currentUser != null && isSignedIn && context.mounted) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                        }
                      },
                    ),
                  ),
                  if (isSignInBtnLoading) ...[
                    SizedBox(width: 20.w),
                    SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 3.w,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                  ]
                ],
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
