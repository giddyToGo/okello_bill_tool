import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:hive/hive.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:okello_bill_tool/firebase_options.dart';
import 'package:okello_bill_tool/logic/cubits/auth/auth_state.dart';
import 'package:okello_bill_tool/logic/cubits/internet/internet_cubit.dart';
import 'package:okello_bill_tool/screens/home_screen.dart';
import 'package:okello_bill_tool/screens/loading_screen.dart';
import 'package:okello_bill_tool/screens/signIn_screen.dart';
import 'package:okello_bill_tool/screens/source.dart';
import 'package:okello_bill_tool/utils/routes/routes.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'dialogs/show_auth_error.dart';
import 'logic/cubits/auth/auth_cubit.dart';
import 'models/user_model.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Hive.init((await path_provider.getApplicationDocumentsDirectory()).path);

  bool boxExists = await Hive.boxExists('users_box');

  if (!boxExists) {}

  await Hive.openBox("users_box");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kIsWeb) {
    await FacebookAuth.i.webInitialize(
        appId: "1184501812387266", cookie: true, xfbml: true, version: "v13.0");
  }

  final internetCubit = InternetCubit(connectivity: Connectivity());

  final app = MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(internetCubit)),
        BlocProvider(create: (context) => internetCubit),
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
        // HomeScreen.id: (_) => const HomeScreen(),
        // SignUpScreen.id: (_) => const SignUpScreen(),
        // SignInScreen.id: (_) => const SignInScreen(),
        // UserProfileScreen.id: (_) => const UserProfileScreen(),
        // UserSettingsScreen.id: (_) => const UserSettingsScreen(),
        // ForgotPasswordScreen.id: (_) => const ForgotPasswordScreen(),
      },
      home: WillPopScope(
        onWillPop: () async {
          final canPop = navigatorKey.currentState!.canPop();
          if (canPop) {
            navigatorKey.currentState!.pop();
            print('-----------------------888888=willpopscope was called');
          }
          return false;
        },
        child: BlocListener<AuthCubit, AuthState1>(
            listener: (context, state) {
              print(
                  '-------------------------------------------------current state is $state .................... CURRENT USER IS: ${state.user.email}');

              state.maybeWhen(loading: (__, _, message) {
                /// If in ---LOADING--- state, then show loading screen with message or 'Loading...'
                LoadingScreen.instance().show(
                  context: context,
                  text: message ?? 'Loading... ',
                );
              }, error: (_, authError, showError) {
                /// if in ---ERROR--- state then show error screen with dialog.
                if (showError == null || showError == true) {
                  showAuthError(
                    authError: authError,
                    context: context,
                  );
                }
                LoadingScreen.instance().hide();
              }, initial: (user, __, message) {
                /// If in ---INITIAL--- state, then show message. if user.signedIn then show homescreen
                LoadingScreen.instance().hide();
                navigatorKey.currentState!.pushNamed(SignInScreen.id);
                message != null
                    ? ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message.toString())))
                    : null;
              }, content: (user, __, message) {
                /// If in ---CONTENT--- state, then show message and navigate to Home Screen
                LoadingScreen.instance().hide();
                navigatorKey.currentState!.pushNamed(HomeScreen.id);
                message != null
                    ? ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message.toString())))
                    : null;
              }, success: (_, __, message) {
                /// if in SUCCESS state, then show message and no navigation
                LoadingScreen.instance().hide();
                message != null
                    ? ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message.toString())))
                    : null;
              }, orElse: () {
                LoadingScreen.instance().hide();
              });
            },
            child: BlocConsumer<InternetCubit, InternetState>(
                listener: (context, state) {
              print(
                  '-------------------------------------------------InternetCubit Listener heard a state of $state');
            }, builder: (context, state) {
              return SafeArea(
                child: Scaffold(
                    body: Column(
                  children: [
                    if (state is InternetDisconnected)
                      Container(
                        color: Colors.red,
                        height: 40,
                        width: double.infinity,
                        child: const Text("Please connect !!!"),
                      ),
                    Expanded(
                      child: Navigator(
                        key: navigatorKey,
                        pages: [MaterialPage(child: SplashScreen())],
                        onGenerateRoute: generateRoutes,
                        onPopPage: (route, _) {
                          print(
                              "------------------------about to pop the page");
                          return false;
                        },
                      ),
                    )
                  ],
                )),
              );
            })),
      ),
    ));
  }
}

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
      print(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isSignedIn ? const HomeScreen() : const SignInScreen();
  }
}
