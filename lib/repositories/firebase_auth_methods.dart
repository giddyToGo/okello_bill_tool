import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:okello_bill_tool/models/user_model.dart';
import 'package:okello_bill_tool/screens/source.dart';
import 'package:twitter_login/twitter_login.dart';

class AuthRepository {
  final _auth = auth.FirebaseAuth.instance;

  /* todo: Implement user sign in flow so that if user already has an account they are automatically linked
        and the user is signed in with the method they were trying to use.
*/

// Check to see if User already has an account with another provider
  // This is pointless because I can't check for existing user when they are signing in with a provider (google, facebook, twitter)...
  // need to figure this out in the future.


  Future<void> documentAI(String filepath) async {
    final project_id = 'okello-billtool';
    final location = 'eu';
    final processor_id = 'a872dd2e350c9a7c';
    final file_path = '';
    final mime_type = 'application/pdf';
    final apiEndpoint = 'https://eu-documentai.googleapis.com/v1/projects/186621583380/locations/eu/processors/a872dd2e350c9a7c:process';

    // final httpClient = await clientViaApp


    late final opts = {"$apiEndpoint": "$location-"};
  }


  Future<bool> checkForExistingUser({required String email}) async {
    final list = await _auth.fetchSignInMethodsForEmail(email);
    // In case list is not empty
    if (list.isNotEmpty) {
      // Return true because there is an existing user using the email address
      return true;
    } else {
      // Return false because email address is not in use
      return false;
    }
  }

  //todo implement update details
// Update User Details in Firebase and then local storage
  Future<void> updateUserDetails(User user) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .set(jsonDecode(user.toJson()));
    } on auth.FirebaseAuthException catch (e) {
      throw e.code;
    }
  }

  // returns a list of sign in options for that email address
  // Future<String> checkForExistingUser({required email}) async {
  //   try {
  //     final message = await _auth.fetchSignInMethodsForEmail(email);
  //     return message.toString();
  //   } on auth.FirebaseAuthException catch (e) {
  //     logger.e(e);
  //     return e.code;
  //   }
  // }

  Future<String?> linkUserCredential(credential) async {
    try {
      _auth.currentUser?.linkWithCredential(credential);
      return 'Sign-in method linked with account';
    } on auth.FirebaseAuthException catch (e) {
      throw e.code;
    }
  }

// Sign Up With Email
  Future<User?> signUpWithEmail(
      {required String email, required String password}) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await sendEmailVerification(email: email);
      return User(
          email: email,
          name: credential.user!.displayName,
          photoURL: credential.user!.photoURL,
          signUpOption: SignUpOption.emailPassword,
          uid: credential.user!.uid,
          signedIn: true);
    } on auth.FirebaseAuthException catch (e) {
      throw e.code;
    }
  }

// Send Email Verification
  Future<String?> sendEmailVerification({required String email}) async {
    if (_auth.currentUser != null) {
      try {
        await _auth.currentUser!.sendEmailVerification();
        return 'email verification sent';
      } on auth.FirebaseAuthException catch (e) {
        throw e.code;
      }
    } else {
      throw ('Current User = null');
    }
  }

// Sign In With email
  Future<User?> signInWithEmail(
      {required String email, required String password}) async {
    final firebaseUser = (await _auth.signInWithEmailAndPassword(
        email: email, password: password))
        .user;
    return User(
        email: email,
        name: firebaseUser?.displayName,
        photoURL: firebaseUser?.photoURL,
        phone: firebaseUser?.phoneNumber,
        uid: firebaseUser?.uid,
        signedIn: true,
        signUpOption: SignUpOption.emailPassword);
  }

// Sign In With Google
  Future<User?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        var googleProvider = auth.GoogleAuthProvider();
        googleProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');
        final firebaseUser = (await _auth.signInWithPopup(googleProvider)).user;

        return User(
            email: firebaseUser!.email!,
            phone: firebaseUser.phoneNumber,
            photoURL: firebaseUser.photoURL,
            name: firebaseUser.displayName,
            uid: firebaseUser.uid,
            signedIn: true,
            signUpOption: SignUpOption.google);
      } else {
        final GoogleSignInAccount? googleSignInAccount =
        await GoogleSignIn(scopes: <String>["email"]).signIn();

        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final firebaseUser =
            (await _auth.signInWithCredential(credential)).user;

        return User(
            email: firebaseUser!.email!,
            phone: firebaseUser.phoneNumber,
            photoURL: firebaseUser.photoURL,
            name: firebaseUser.displayName,
            uid: firebaseUser.uid,
            signedIn: true,
            signUpOption: SignUpOption.google);
      }
    } on auth.FirebaseAuthException {
      rethrow;
    }
  }

// Sign Up With Facebook
  Future<User?> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      final credential =
      auth.FacebookAuthProvider.credential(loginResult.accessToken!.token);

      final firebaseUser = (await _auth.signInWithCredential(credential)).user;
      final facebookUser = await FacebookAuth.instance.getUserData();

      final bool existingImage =
          firebaseUser?.photoURL.toString().contains(firebaseUser.uid) ?? false;

      return User(
          email: firebaseUser!.email!,
          phone: firebaseUser.phoneNumber,
          photoURL: existingImage
              ? firebaseUser.photoURL
              : facebookUser["picture"]["data"]["url"],
          name: firebaseUser.displayName,
          uid: firebaseUser.uid,
          signedIn: true,
          signUpOption: SignUpOption.facebook);

      // return 'Signed in successfully with Facebook';
    } on auth.FirebaseAuthException {
      rethrow;
    }
  }

//signInWithTwitter
  Future<User?> signInWithTwitter() async {
    try {
      final twitterLogin = TwitterLogin(
          apiKey: "b6AOYlId3dXgDU62Q2PGE6qGP",
          apiSecretKey: "ZNUfPAR2hEmNiUDh357N9nzYt3toMzjEYbWon44E6tIC66OBzX",
          redirectURI: "okello-billtool://");
      // Trigger the sign-in flow
      final authResult = await twitterLogin.loginV2();

      switch (authResult.status) {
        case TwitterLoginStatus.loggedIn:
          final twitterAuthCredential = auth.TwitterAuthProvider.credential(
              accessToken: authResult.authToken!,
              secret: authResult.authTokenSecret!);
          final firebaseUser =
              (await _auth.signInWithCredential(twitterAuthCredential)).user;

          return User(
              email: firebaseUser!.email!,
              phone: firebaseUser.phoneNumber,
              photoURL: firebaseUser.photoURL,
              name: firebaseUser.displayName,
              uid: firebaseUser.uid,
              signedIn: true,
              signUpOption: SignUpOption.twitter);

        case TwitterLoginStatus.cancelledByUser:
          break;
        case TwitterLoginStatus.error:
          break;
        default:
          return null;
      }
    } on auth.FirebaseAuthException {
      rethrow;
    }
  }

// Reset Password
  Future<String?> forgottenPassword({required String email}) async {
    try {
      _auth.sendPasswordResetEmail(email: email);
      return 'password reset link sent';
    } on auth.FirebaseAuthException {
      rethrow;
    }
  }

// Delete Account
  Future<String?> deleteUser() async {
    try {
      final user = _auth.currentUser!;
      await user.delete();
      return 'user deleted';
    } on auth.FirebaseAuthException {
      rethrow;
    }
  }

// Sign Out User
  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();

      _auth.signOut();
    } on auth.FirebaseAuthException {
      rethrow;
    }
  }

  Future<String> uploadFile(
      {required String path, required String? userId}) async {
    final storageBucketpath =
        '$userId/${DateTime
        .now()
        .microsecondsSinceEpoch
        .toString()}';

    final ref = FirebaseStorage.instance.ref().child(storageBucketpath);
    var uploadTask = ref.putFile(File(path));
    final snapshot = await uploadTask.whenComplete(() => {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    return urlDownload;
  }

  Future<Map<String, dynamic>?> getFireStoreUser(String? uid) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
      dynamic data = await docRef.get().then((DocumentSnapshot doc) async {
        final data = doc.data() as Map<String, dynamic>;

        if (data == null) {
          return {};
        } else {
          return data;
        }
      });
      return data;
    } catch (e) {
      rethrow;
    }
  }
}
