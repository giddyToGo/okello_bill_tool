import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:okello_bill_tool/screens/home_screen.dart';
import 'package:okello_bill_tool/screens/signIn_screen.dart';
import 'package:okello_bill_tool/screens/source.dart';

import '../logic/cubits/auth/auth_cubit.dart';
import '../main.dart';
import '../models/user_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isSignedIn = false;

  @override
  void initState() {
    super.initState();

    final user = Hive.box("users_box").get("user") as String?;
    if (user != null) {
      isSignedIn = true;
      context.read<AuthCubit>().initialiseUser(User.fromJson(user));
    }
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3), () {
      if (isSignedIn) {
        navigatorKey.currentState!.pushNamed(HomeScreen.id);
      } else {
        navigatorKey.currentState!.pushNamed(SignInScreen.id);
      }
    });

    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [kGradient1, kGradient2])),
          child: Center(
            child:
                Container(child: Image.asset('assets/images/splash_logo.png')),
          ),
        ),
      ),
    );
  }
}
