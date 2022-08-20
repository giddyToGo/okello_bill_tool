import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:hive/hive.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:okello_bill_tool/firebase_options.dart';
import 'package:okello_bill_tool/logic/cubits/auth/auth_state.dart';
import 'package:okello_bill_tool/logic/cubits/internet/internet_cubit.dart';
import 'package:okello_bill_tool/screens/forgotPassword_screen.dart';
import 'package:okello_bill_tool/screens/home_screen.dart';
import 'package:okello_bill_tool/screens/loading_screen.dart';
import 'package:okello_bill_tool/screens/signIn_screen.dart';
import 'package:okello_bill_tool/screens/signUp_screen.dart';
import 'package:okello_bill_tool/screens/sign_up_page.dart';
import 'package:okello_bill_tool/screens/source.dart';
import 'package:okello_bill_tool/screens/user_profile_screen.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'dialogs/show_auth_error.dart';
import 'logic/cubits/auth/auth_cubit.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Hive.init((await path_provider.getApplicationDocumentsDirectory()).path);
  await Hive.openBox("users_box");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kIsWeb) {
    await FacebookAuth.i.webInitialize(
        appId: "1184501812387266", cookie: true, xfbml: true, version: "v13.0");
  }

  final app = MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(
            create: (context) =>
                InternetCubit(
                  connectivity: Connectivity(),
                )),
      ],
      child: MyApp(
        connectivity: Connectivity(),
      ));

  runApp(app);
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  final Connectivity connectivity;

  const MyApp({Key? key, required this.connectivity}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
        child: MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          title: 'Okello BillsTool',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          routes: {
            HomeScreen.id: (_) => const HomeScreen(),
            SignUpPage.id: (_) => const SignUpPage(),
            SignUpScreen.id: (_) => const SignUpScreen(),
            SignInScreen.id: (_) => const SignInScreen(),
            UserProfileScreen.id: (_) => const UserProfileScreen(),
            UserSettingsScreen.id: (_) => const UserSettingsScreen(),
            ForgotPasswordScreen.id: (_) => const ForgotPasswordScreen(),
          },
          home: BlocListener<AuthCubit, AuthState1>(
              listener: (context, state) {
                state.maybeWhen(loading: (__, _, message) {
                  LoadingScreen.instance().show(
                    context: context,
                    text: message ?? 'Loading... ',
                  );
                },
                    error: (_, authError) {
                      if (authError == "Intenret ") {

                      }
                      LoadingScreen.instance().hide();
                      showAuthError(
                        authError: authError,
                        context: context,
                      );
                    },
                    content: (_, __, message) {
                      LoadingScreen.instance().hide();
                      message != null
                          ? ScaffoldMessenger.of(context)
                          .showSnackBar(
                          SnackBar(content: Text(message.toString())))
                          : null;
                      Navigator.pushNamed(context, HomeScreen.id);
                    },
                    initial: (user, __, message) {
                      LoadingScreen.instance().hide();
                      bool signedIn = user.signedIn ?? false;
                      !signedIn
                          ? Navigator.pushNamed(context, SignInScreen.id)
                          : null;
                      message != null
                          ? ScaffoldMessenger.of(context)
                          .showSnackBar(
                          SnackBar(content: Text(message.toString())))
                          : null;
                    },
                    success: (_, __, message) {
                      LoadingScreen.instance().hide();
                      message != null
                          ? ScaffoldMessenger.of(context)
                          .showSnackBar(
                          SnackBar(content: Text(message.toString())))
                          : null;
                    },
                    orElse: () {
                      LoadingScreen.instance().hide();
                    });
              },
              child: BlocListener<InternetCubit, InternetState>(
                listener: (context, state) {
                  if (state is InternetDisconnected) {
                    LoadingScreen.instance().show(
                      context: context,
                      text: 'Internet is down, please reconnect',
                    );
                  } else if (state is InternetConnected) {
                    LoadingScreen.instance().hide();
                  }
                },
                child: const SplashScreen(),
              )),
        ));
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final bool isSignedIn;

  @override
  void initState() {
    super.initState();

    final jsonUser = Hive.box("users_box").get("user");
    context.read<AuthCubit>().initialiseFromLocalStorage();
    User user = User.fromJson(jsonUser);
    isSignedIn = user.signedIn ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // bool state = context.read<AuthCubit>().checkForExistingUserInLocalStorage();
    // bool? isSignedIn = context.read<AuthCubit>().state.user.signedIn ?? false;

    return isSignedIn ? const HomeScreen() : const SignInScreen();
  }
}
