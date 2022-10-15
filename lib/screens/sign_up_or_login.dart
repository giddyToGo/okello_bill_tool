import 'package:okello_bill_tool/screens/source.dart';

import '../logic/cubits/auth/auth_cubit.dart';

class SignUpOrLogin extends StatefulWidget {
  const SignUpOrLogin({Key? key}) : super(key: key);
  static const id = "SignUpOrLogin";

  @override
  State<SignUpOrLogin> createState() => _SignUpOrLoginState();
}

class _SignUpOrLoginState extends State<SignUpOrLogin> {
  @override
  Widget build(BuildContext context) {
    final isLoading = context
        .watch<AuthCubit>()
        .state
        .maybeWhen(loading: (user, e, message) => true, orElse: () => false);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 90),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/images/signuploginlogo.png'),
              SizedBox(
                height: 30,
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              kGradient1,
                              kGradient2,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                              fontFamily: 'Homizio',
                              fontSize: 28,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    color: Color.fromARGB(255, 64, 12, 12),
                    child: Center(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: () {},
                        child: Text('Log in',
                            style: TextStyle(
                              fontFamily: 'Homizio',
                              fontSize: 28,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
