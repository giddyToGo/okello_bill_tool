import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:okello_bill_tool/screens/forgotPassword_screen.dart';
import 'package:okello_bill_tool/screens/signIn_screen.dart';
import 'package:okello_bill_tool/screens/signUp_screen.dart';
import 'package:okello_bill_tool/screens/user_profile_screen.dart';

import '../../screens/home_screen.dart';
import '../../screens/splash_screen.dart';

Route generateRoutes(RouteSettings settings) {
  log("settings : ${settings.name}");
  late final Widget page;
  if (settings.name == "/") {
    page = const SplashScreen();
  }
  else if (settings.name == HomeScreen.id) {
    page = HomeScreen();
  } else if (settings.name == ForgotPasswordScreen.id) {
    page = const ForgotPasswordScreen();
  } else if (settings.name == SignInScreen.id) {
    page = const SignInScreen();
  } else if (settings.name == SignUpScreen.id) {
    page = const SignUpScreen();
  } else if (settings.name == UserProfileScreen.id) {
    page = const UserProfileScreen();
  } else {
    page = const SignInScreen();
  }
  return MaterialPageRoute(builder: (context) {
    return page;
  });
}
