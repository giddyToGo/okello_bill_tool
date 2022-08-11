import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:hive/hive.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:okello_bill_tool/firebase_options.dart';
import 'package:okello_bill_tool/logic/bloc/auth_bloc.dart';
import 'package:okello_bill_tool/logic/cubits/auth/auth_state.dart';
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

  final app = MultiBlocProvider(providers: [
    BlocProvider(create: (_) => AuthCubit()),
    BlocProvider(create: (_) => AuthBloc()..add(const AppEventInitialize()))
  ], child: const MyApp());

  runApp(app);
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

///  <----------------Issue trying to get this to work so my snack bars show across navigation

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
              state.maybeWhen(loading: (__, _) {
                LoadingScreen.instance().show(
                  context: context,
                  text: 'Loading... ',
                );
              }, error: (_, authError) {
                LoadingScreen.instance().hide();
                showAuthError(
                  authError: authError,
                  context: context,
                );
              }, content: (_, __) {
                LoadingScreen.instance().hide();
                Navigator.pushNamed(context, HomeScreen.id);
              }, initial: (_, __) {
                LoadingScreen.instance().hide();
                Navigator.pushNamed(context, SignInScreen.id);
              }, userUpdated: (_, __) {
                LoadingScreen.instance().hide();
              }, orElse: () {
                LoadingScreen.instance().hide();
              });
            },
            child: const SplashScreen(),
          )),
    );
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
    // checkIfUserIsInLocalStorage checks for a user in local storage and emits content state if so. if not, emits initial state.
    // context.read<AuthCubit>().checkIfUserExistsInLocalStorage();
    // isSignedIn = context.read<AuthCubit>().state.user.email.isNotEmpty;

    isSignedIn = context
        .read<AuthCubit>()
        .state
        .maybeWhen(content: (_, __) => true, orElse: () => false);
  }

  @override
  Widget build(BuildContext context) {
    return isSignedIn ? const HomeScreen() : const SignInScreen();
  }
}
