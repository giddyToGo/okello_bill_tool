import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserSettingsScreen extends StatefulWidget {
  static const id = 'UserSettingsScreen';

  const UserSettingsScreen({Key? key}) : super(key: key);

  @override
  _UserSettingsScreenState createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  final Color _color1 = const Color(0xff777777);
  final Color _color2 = const Color(0xFF515151);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          elevation: 0,
          title: const Text(
            'Account',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          backgroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          actions: [
            GestureDetector(
                onTap: () {}, child: Icon(Icons.email, color: _color1)),
            IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: _color1,
                ),
                onPressed: () {}),
          ],
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: Colors.grey[100],
                height: 1.0,
              )),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _createAccountInformation(),
            _createListMenu('Change Password'),
            Divider(height: 0, color: Colors.grey[400]),
            _createListMenu('Set Address'),
            Divider(height: 0, color: Colors.grey[400]),
            _createListMenu('Order List'),
            Divider(height: 0, color: Colors.grey[400]),
            _createListMenu('Review'),
            Divider(height: 0, color: Colors.grey[400]),
            _createListMenu('Payment Method'),
            Divider(height: 0, color: Colors.grey[400]),
            _createListMenu('Last Seen Product'),
            Divider(height: 0, color: Colors.grey[400]),
            _createListMenu('Change Language'),
            Divider(height: 0, color: Colors.grey[400]),
            _createListMenu('Notification Setting'),
            Divider(height: 0, color: Colors.grey[400]),
            _createListMenu('About'),
            Divider(height: 0, color: Colors.grey[400]),
            _createListMenu('Terms and Conditions'),
            Divider(height: 0, color: Colors.grey[400]),
            _createListMenu('Privacy Policy'),
            Divider(height: 0, color: Colors.grey[400]),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 18, 0, 0),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.power_settings_new,
                        size: 20, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Sign Out',
                        style: TextStyle(fontSize: 15, color: Colors.black)),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _createAccountInformation() {
    final double profilePictureSize = MediaQuery.of(context).size.width / 4;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: profilePictureSize,
            height: profilePictureSize,
            child: GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                backgroundColor: Colors.grey[200],
                radius: profilePictureSize,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: profilePictureSize * 2,
                  child: const Hero(
                    tag: 'profilePicture',
                    child: Icon(
                      Icons.person_outline_sharp,
                      size: 75,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16, height: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Robert Steven',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text('Account Information',
                          style: TextStyle(fontSize: 14, color: _color1)),
                      const SizedBox(
                        width: 8,
                      ),
                      const Icon(Icons.chevron_right,
                          size: 20, color: Colors.black)
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _createListMenu(String menuTitle) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 18, 0, 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(menuTitle, style: TextStyle(fontSize: 15, color: _color2)),
            const Icon(Icons.chevron_right, size: 20, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
// class UserProfileScreen extends StatelessWidget {
//   const UserProfileScreen({Key? key}) : super(key: key);
//   static const String id = 'UserProfileScreen';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(child: Text("demo profile page")),
//         appBar: AppBar(
//             title: Text(User.fromJson(Hive.box("users_box").get("user")).name ??
//                 "No name")));
//   }
// }
