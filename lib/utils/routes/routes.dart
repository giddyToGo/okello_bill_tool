import 'package:flutter/material.dart';
import 'package:okello_bill_tool/screens/forgotPassword_screen.dart';
import 'package:okello_bill_tool/screens/signIn_screen.dart';
import 'package:okello_bill_tool/screens/signUp_screen.dart';
import 'package:okello_bill_tool/screens/user_profile_screen.dart';

import '../../screens/home_screen.dart';

Route generateRoutes(RouteSettings settings) {
  late final Widget page;
  if (settings.name == HomeScreen.id) {
    page = HomeScreen();
  } else if (settings.name == ForgotPasswordScreen.id) {
    page = ForgotPasswordScreen();
  } else if (settings.name == SignInScreen.id) {
    page = SignInScreen();
  } else if (settings.name == SignUpScreen.id) {
    page = SignUpScreen();
  } else if (settings.name == UserProfileScreen.id) {
    page = UserProfileScreen();
  } else {
    page = SignInScreen();
  }
  return MaterialPageRoute(builder: (context) {
    return page;
  });
}
