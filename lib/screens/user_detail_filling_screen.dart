import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserDetailFillingScreen extends ConsumerStatefulWidget {
  const UserDetailFillingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserDetailFillingScreenState();
}

class _UserDetailFillingScreenState extends ConsumerState<UserDetailFillingScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('User Detail Filling Screen'),
      ),
    );
  }
}
