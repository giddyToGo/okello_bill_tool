import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'dialogs/show_auth_error.dart';
import 'logic/cubits/auth/auth_cubit.dart';
import 'logic/cubits/auth/auth_state.dart';
import 'logic/cubits/internet/internet_cubit.dart';
import 'screens/forgotPassword_screen.dart';
import 'screens/home_screen.dart';
import 'screens/loading_screen.dart';
import 'screens/signIn_screen.dart';
import 'screens/signUp_screen.dart';
import 'screens/source.dart';
import 'screens/splash_screen.dart';
import 'screens/user_profile_screen.dart';

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
        HomeScreen.id: (_) => HomeScreen(),
        SignUpScreen.id: (_) => const SignUpScreen(),
        SignInScreen.id: (_) => const SignInScreen(),
        UserProfileScreen.id: (_) => const UserProfileScreen(),
        UserSettingsScreen.id: (_) => const UserSettingsScreen(),
        ForgotPasswordScreen.id: (_) => const ForgotPasswordScreen(),
      },
      home: BlocListener<AuthCubit, AuthState1>(
          listener: (context, state) {
            logger.i(
                'current state is $state ......... current user is: ${state.user.email}');

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
              Navigator.of(context).pushNamed(SignInScreen.id);
              message != null
                  ? ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(message.toString())))
                  : null;
            }, content: (user, __, message) {
              /// If in ---CONTENT--- state, then show message and navigate to Home Screen
              LoadingScreen.instance().hide();
              Navigator.of(context).pushNamed(HomeScreen.id);
              message != null
                  ? ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(message.toString())))
                  : null;
            }, success: (_, __, message) {
              /// if in SUCCESS state, then show message and no navigation
              LoadingScreen.instance().hide();
              message != null
                  ? ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(message.toString())))
                  : null;
            }, orElse: () {
              LoadingScreen.instance().hide();
            });
          },
          child: BlocConsumer<InternetCubit, InternetState>(
              listener: (context, state) {
            logger.i('InternetCubit Listener heard a state of $state');
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
                  const SplashScreen()
                ],
              )),
            );
          })),
    ));
  }
}
