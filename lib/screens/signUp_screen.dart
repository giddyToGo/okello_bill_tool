import 'package:okello_bill_tool/screens/signIn_screen.dart';

import '../logic/cubits/auth/auth_cubit.dart';
import '../main.dart';
import '../repositories/firebase_auth_methods.dart';
import 'source.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static const String id = 'SignUpScreen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  initState() {
    authCubit = BlocProvider.of<AuthCubit>(context);
  }

  String email = '';
  String password = '';
  bool _obscureText = true;
  IconData _iconVisible = Icons.visibility_off;

  late AuthCubit authCubit;
  final authMethods = AuthRepository();

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

  void snackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
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
                child: Image.asset('assets/images/logo_dark.png', height: 120)),
            ListView(
              children: <Widget>[
                // create form login
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.fromLTRB(
                      32, MediaQuery.of(context).size.height / 3.5 - 72, 32, 0),
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
                              'SIGN UP',
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
                            height: 40,
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
                                  await context.read<AuthCubit>().authSignUp(
                                      email: email, password: password);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    'CREATE ACCOUNT',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                          ),
                        ],
                      )),
                ),
                const SizedBox(height: 25),
                Center(
                  child: Text('Sign up with:',
                      style: TextStyle(fontSize: 15, color: Colors.grey[700])),
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
                          await context
                              .read<AuthCubit>()
                              .authSignInWithGoogle();
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
                          await context
                              .read<AuthCubit>()
                              .authSignInWithFacebook();
                        },
                        child: const Image(
                            image: AssetImage('assets/images/facebook.png'),
                            width: 40,
                            color: kMainColor),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await context
                              .read<AuthCubit>()
                              .authSignInWithTwitter();
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
                      Text('Already have an account? ',
                          style: TextStyle(color: Colors.grey[700])),
                      GestureDetector(
                        onTap: () {
                          navigatorKey.currentState!.pushNamed(SignInScreen.id);
                        },
                        child: const Text(
                          'Sign In',
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
        ),
      ),
    );
  }
}
