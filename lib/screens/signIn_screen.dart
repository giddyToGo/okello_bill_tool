import 'package:okello_bill_tool/dialogs/auth_error.dart';
import 'package:okello_bill_tool/screens/forgotPassword_screen.dart';
import 'package:okello_bill_tool/screens/signUp_screen.dart';

import '../dialogs/show_auth_error.dart';
import '../logic/cubits/auth/auth_cubit.dart';
import '../repositories/firebase_auth_methods.dart';
import 'source.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);
  static const String id = 'SignInScreen';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String email = '';
  String password = '';
  bool _obscureText = true;
  IconData _iconVisible = Icons.visibility_off;
  final authMethods = AuthRepository();

  // AuthCubit authCubit = AuthCubit();

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
      if (_obscureText == true) {
        _iconVisible = Icons.visibility_off;
      } else {
        _iconVisible = Icons.visibility;
      }
    });
  }

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void snackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: Platform.isIOS
              ? SystemUiOverlayStyle.light
              : const SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.light),
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 3.5,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [kGradientTop, kGradientBottom],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
              ),
              // set your logo here
              Container(
                  margin: EdgeInsets.fromLTRB(
                      0, MediaQuery.of(context).size.height / 20, 0, 0),
                  alignment: Alignment.topCenter,
                  child:
                      Image.asset('assets/images/logo_dark.png', height: 120)),
              ListView(
                children: <Widget>[
                  // create form login
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.fromLTRB(32,
                        MediaQuery.of(context).size.height / 3.5 - 72, 32, 0),
                    color: Colors.white,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 30,
                          ),
                          const Center(
                            child: Text(
                              'SIGN IN',
                              style: TextStyle(
                                  color: kMainColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: emailController,
                            onChanged: (value) {
                              email = value;
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[600]!)),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: kUnderlineColor),
                                ),
                                labelText: 'Email',
                                labelStyle: TextStyle(color: Colors.grey[700])),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: passwordController,
                            onChanged: (value) {
                              password = value;
                            },
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey[600]!)),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: kUnderlineColor),
                              ),
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.grey[700]),
                              suffixIcon: IconButton(
                                  icon: Icon(_iconVisible,
                                      color: Colors.grey[700], size: 20),
                                  onPressed: () {
                                    _toggleObscureText();
                                  }),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, ForgotPasswordScreen.id);
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: double.maxFinite,
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) => kMainColor,
                                ),
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                              ),
                              onPressed: () async {
                                if (emailController.text.isEmpty) {
                                  showAuthError(
                                    authError: const AuthError(
                                        dialogTitle: 'Email Error',
                                        dialogText: 'email is not good'),
                                    context: context,
                                  );
                                } else if (passwordController.text.isEmpty) {
                                  showAuthError(
                                    authError: const AuthError(
                                        dialogTitle: 'Password Error',
                                        dialogText: 'password is empty'),
                                    context: context,
                                  );
                                } else {
                                  String message = await context
                                      .read<AuthCubit>()
                                      .authSignIn(
                                          email: email, password: password);
                                  snackBar(message);
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  'SIGN IN',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: Text('Sign in with:',
                        style:
                            TextStyle(fontSize: 15, color: Colors.grey[700])),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () async {
                            String message = await context
                                .read<AuthCubit>()
                                .authSignInWithGoogle();
                            snackBar(message);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 4,
                                  blurRadius: 5,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                            ),
                            child: const Image(
                              image: AssetImage('assets/images/google.png'),
                              width: 24,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            String message = await context
                                .read<AuthCubit>()
                                .authSignInWithFacebook();
                            snackBar(message);
                          },
                          child: const Image(
                              image: AssetImage('assets/images/facebook.png'),
                              width: 40,
                              color: kMainColor),
                        ),
                        GestureDetector(
                          onTap: () async {
                            String message = await context
                                .read<AuthCubit>()
                                .authSignInWithTwitter();
                            snackBar(message);
                          },
                          child: const Image(
                              image: AssetImage('assets/images/twitter.png'),
                              width: 40,
                              color: kMainColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // create sign up link
                  Center(
                    child: Wrap(
                      children: <Widget>[
                        Text("Don't have an account? ",
                            style: TextStyle(color: Colors.grey[700])),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, SignUpScreen.id);
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                                color: kMainColor, fontWeight: FontWeight.w700),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
