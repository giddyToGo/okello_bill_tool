import 'dart:async';

import 'package:hive/hive.dart';
import 'package:okello_bill_tool/screens/home_screen.dart';
import 'package:okello_bill_tool/screens/signIn_screen.dart';
import 'package:okello_bill_tool/screens/source.dart';

import '../logic/cubits/auth/auth_cubit.dart';
import '../models/user_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    final jsonUser = Hive.box("users_box").get("user") as String?;
    context.read<AuthCubit>().initialiseUser(jsonUser);
  }

  @override
  Widget build(BuildContext context) {
    /*  Timer(const Duration(seconds: 3), () {
      if (isSignedIn) {
        Navigator.of(context).pushNamed(HomeScreen.id);
      } else {
       Navigator.of(context).pushNamed(SignInScreen.id);
      }
    });*/

    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [kGradient1, kGradient2])),
          child: Center(
            child: Image.asset('assets/images/splash_logo.png'),
          ),
        ),
      ),
    );
  }
}
