import 'package:okello_bill_tool/main.dart';
import 'package:okello_bill_tool/screens/user_profile_screen.dart';

import '../logic/cubits/auth/auth_cubit.dart';
import '../logic/cubits/auth/auth_state.dart';
import 'source.dart';

/* todo: create a home page that includes the basic structure for the app:
    This will include: Navigation bar, Account Action Button, Tutorial, Suppliers, Groups > Flatmate in Group,
    Bills in Group, Messages in Group
    The objective of the home page is to show the user all the info they would want to see at a glance + quick access to everything else.
    This may include: current & upcoming bills (shown who has paid and who hasn't), pie chart for bill costs, quick-tips/tutorials,
    notifications,
 */

//todo: get a name and a logo!

class HomeScreen extends StatefulWidget {
  static const String id = 'HomeScreen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // print(
    //     '---------initialised homeScreen, user is:  ${context.read<AuthCubit>().state.user.email}');
  }

  void snackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  String email = '';
  String password = '';
  final bool _obscureText = true;
  final IconData _iconVisible = Icons.visibility_off;

  @override
  Widget build(BuildContext context) {
    var state = context.read<AuthCubit>().state;

    final user = context.watch<AuthCubit>().state.user;
    final profilePic = user.photoURL;

    // print(
    //     '-----------------------------built homeScreen, user is:  ${context.read<AuthCubit>().state.user.email}');

    return Scaffold(
      body: BlocListener<AuthCubit, AuthState1>(
        listener: (context, state) {
          final isSuccess = state.maybeWhen(
              content: (_, error, message) => true, orElse: () => false);
          if (isSuccess) navigatorKey.currentState!.pushNamed(HomeScreen.id);
        },
        child: ListView(children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(0, 18, 0, 0),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                await context.read<AuthCubit>().authSignOut(state.user);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.power_settings_new, size: 20, color: Colors.black),
                  SizedBox(width: 8),
                  Text('Sign Out',
                      style: TextStyle(fontSize: 15, color: Colors.black)),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 18, 0, 0),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                await context.read<AuthCubit>().authDeleteAccount();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.power_settings_new, size: 20, color: Colors.black),
                  SizedBox(width: 8),
                  Text('Delete User Account',
                      style: TextStyle(fontSize: 15, color: Colors.black)),
                ],
              ),
            ),
          ),
          TextField(
            onChanged: (value) {
              email = value;
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!)),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: const BorderSide(color: kUnderlineColor),
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
                  borderSide: BorderSide(color: Colors.grey[600]!)),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: kUnderlineColor),
              ),
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.grey[700]),
              suffixIcon: IconButton(
                  icon: Icon(_iconVisible, color: Colors.grey[700], size: 20),
                  onPressed: () {
                    // _toggleObscureText();
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
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) => kMainColor,
                  ),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
                ),
                onPressed: () async {
                  await context
                      .read<AuthCubit>()
                      .checkForExistingUserInFirebase(email: email);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'CHECK FOR USER',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                )),
          ),
          SizedBox(
            width: double.maxFinite,
            child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) => kMainColor,
                  ),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
                ),
                onPressed: () async {
                  // final image = await picker.pickImage(
                  //   source: ImageSource.gallery,);
                  //
                  // if (image == null) {
                  //   return;
                  // }
                  // String message = await context
                  //     .read<AuthCubit>()
                  //     .authUploadImage(filePathToUpload: image.path);
                  // snackBar(message);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Upload Image',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                )),
          ),
          SizedBox(
            width: double.maxFinite,
            child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) => kMainColor,
                  ),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
                ),
                onPressed: () {
                  navigatorKey.currentState!.pushNamed(UserProfileScreen.id);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Navigate to User Page',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                )),
          ),
          TextField(
            enabled: false,
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!)),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: kUnderlineColor),
                ),
                labelText: ' email: ${user.email}',
                labelStyle: TextStyle(color: Colors.grey[700])),
          ),
          TextField(
            enabled: false,
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!)),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: kUnderlineColor),
                ),
                labelText: ' displayName: ${user.name}',
                labelStyle: TextStyle(color: Colors.grey[700])),
          ),
          TextField(
            enabled: false,
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!)),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: kUnderlineColor),
                ),
                labelText: ' phoneNumber: ${user.phone}',
                labelStyle: TextStyle(color: Colors.grey[700])),
          ),
          TextField(
            onTap: () {},
            enabled: false,
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[600]!)),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: const BorderSide(color: kUnderlineColor),
                ),
                labelText: ' photoUrl: ${user.photoURL}',
                labelStyle: TextStyle(color: Colors.grey[700], fontSize: 10)),
          ),
          profilePic != null && profilePic != ''
              ? Image.network("${user.photoURL}".toString())
              : Text(
                  'photo is null(${profilePic == null ? true : false}) or empty (${profilePic == '' ? true : false})')
        ]),
      ),
    );
  }
}
