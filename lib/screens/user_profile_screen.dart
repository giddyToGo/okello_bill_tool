import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../logic/cubits/auth/auth_cubit.dart';
import 'source.dart';

class UserProfileScreen extends StatefulWidget {
  static String id = 'UserProfileScreen';

  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final Color _color1 = const Color(0xFF0181cc);

  bool editEnabled = false;

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  String? profilePic = '';

  void snackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state.user;
    emailController.text = user.email;
    nameController.text = user.name ?? "";
    phoneController.text = user.phone ?? "";
    profilePic = user.profilePic ??
        "https://media.istockphoto.com/photos/snowcapped-k2-peak-picture-id1288385045?k=20&m=1288385045&s=612x612&w=0&h=kcZXuKvLsEbbGakLlcZpolhBT7PyC9AQWiv2kZ7aHfQ=";
  }

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state.user;

    double topHeight = MediaQuery.of(context).size.height / 3;
    if (kIsWeb) {
      topHeight = MediaQuery.of(context).size.height / 2.5;
    }
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: Platform.isIOS
            ? SystemUiOverlayStyle.light
            : const SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.light),
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                height: topHeight,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [kGradientTop, kGradientBottom],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child:
                            const Icon(Icons.arrow_back, color: Colors.white)),
                    GestureDetector(
                        onTap: () {
                          editEnabled = !editEnabled;
                          print('editing is set to $editEnabled');
                          setState(() {});
                        },
                        child: !editEnabled
                            ? const Text('Edit',
                                style: TextStyle(color: Colors.white))
                            : const Text('Editing...',
                                style: TextStyle(color: Colors.white))),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(
                    top: (MediaQuery.of(context).size.height / 8)),
                child: Image.asset('assets/images/logo_horizontal.png',
                    height: 30, color: Colors.white),
              ),
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(
                    top: (topHeight) - MediaQuery.of(context).size.width / 5.5),
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        editEnabled ? _showAlertDialog(context) : null;
                      },
                      child: Stack(children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: MediaQuery.of(context).size.width / 5.5,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius:
                                (MediaQuery.of(context).size.width / 5.5) - 4,
                            backgroundImage:
                                Image.network(profilePic!, fit: BoxFit.fill)
                                    .image,
                            //   child: Image.network(profilePic, fit: BoxFit.fill),
                          ),
                        ),
                        Container(
                          width: 30,
                          height: 30,
                          margin: EdgeInsets.only(
                              top: 0,
                              left: MediaQuery.of(context).size.width / 4),
                          child: !editEnabled
                              ? Container()
                              : Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 1,
                                  child: const Icon(Icons.edit,
                                      size: 12, color: kBlack55),
                                ),
                        ),
                      ]),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(top: 64),
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.person, color: _color1, size: 20),
                              const SizedBox(
                                width: 20,
                              ),
                              if (!editEnabled)
                                Flexible(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(user.name ?? "",
                                      style: kProfilePageDetailText),
                                )),
                              if (editEnabled)
                                Flexible(
                                    child: Container(
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  child: Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: TextField(
                                        controller: nameController,
                                        obscureText: false,
                                        decoration: InputDecoration.collapsed(
                                          hintText:
                                              'Enter your display name here',
                                        ),
                                        style: kProfilePageDetailText),
                                  ),
                                ))
                            ],
                          ),
                          // const SizedBox(height: 24),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.email, color: _color1, size: 20),
                              const SizedBox(
                                width: 20,
                              ),
                              if (!editEnabled)
                                Flexible(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: user.email != ""
                                      ? Text(user.email,
                                          style: kProfilePageDetailText)
                                      : const Text(
                                          'Please update your email address'),
                                )),
                              if (editEnabled)
                                Flexible(
                                    child: Container(
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  child: Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: TextField(
                                        controller: emailController,
                                        obscureText: false,
                                        decoration:
                                            const InputDecoration.collapsed(
                                          hintText: 'Enter your email here',
                                        ),
                                        style: kProfilePageDetailText),
                                  ),
                                ))
                            ],
                          ),
                          // const SizedBox(height: 24),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.phone_android,
                                  color: _color1, size: 20),
                              const SizedBox(
                                width: 20,
                              ),
                              if (!editEnabled)
                                Flexible(
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: user.phone != ''
                                          ? Text(user.phone ?? "",
                                              style: kProfilePageDetailText)
                                          : const Text(
                                              'Please update your phone number')),
                                ),
                              if (editEnabled)
                                Flexible(
                                    child: Container(
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  child: Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: TextField(
                                        controller: phoneController,
                                        enabled: editEnabled,
                                        obscureText: false,
                                        decoration:
                                            const InputDecoration.collapsed(
                                          hintText:
                                              'Enter your phone number here',
                                        ),
                                        style: kProfilePageDetailText),
                                  ),
                                )),
                            ],
                          ),
                          if (editEnabled)
                            // const SizedBox(
                            //   height: 30,
                            // ),
                            if (editEnabled)
                              TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
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
                                    /// implement update user here
                                    await context
                                        .read<AuthCubit>()
                                        .updateUserDetails(user.copyWith(
                                            name: nameController.text,
                                            phone: phoneController.text,
                                            email: emailController.text));
                                    editEnabled = !editEnabled;
                                    setState(() {});
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      'Save User Information',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    final user = context.read<AuthCubit>().state.user;
    // set up the buttons
    Widget cancelButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('No', style: TextStyle(color: Colors.blue)));
    Widget continueButton = TextButton(
        onPressed: () async {
          final XFile? image = await picker.pickImage(
            source: ImageSource.gallery,
          );

          print('image = $image');

          if (image == null) {
            editEnabled = !editEnabled;
            setState(() {});

            print('image = null');
            return;
          } else if (image != null) {
            //emit new state with updated user
            // await context
            //     .read<AuthCubit>()
            //     .updateUserDetails(user.copyWith(profilePic: image.path));
            print('this is the image path: ${image.path}');

            String message = await context
                .read<AuthCubit>()
                .authUploadImage(filePathToUpload: image.path);
            print('message = $message');

            snackBar(message);

            editEnabled = !editEnabled;

            Navigator.pop(context);
          }
        },
        child: const Text('Yes', style: TextStyle(color: Colors.blue)));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: const Text('Edit Profile Picture ?'),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
