import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:okello_bill_tool/models/user_model.dart';
import 'package:twitter_login/twitter_login.dart';

class AuthRepository {
  final _auth = auth.FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();

// Check to see if User already has an account with another provider
  // This is pointless because I can't check for existing user when they are signing in with a provider (google, facebook, twitter)...
  // need to figure this out in the future.
  /* todo: Implement user sign in flow so that if user already has an account they are automatically linked
        and the user is signed in with the method they were trying to use.
*/
  // Future<bool> checkForExistingUser({required String email}) async {
  //   final list = await _auth.fetchSignInMethodsForEmail(email);
  //   // In case list is not empty
  //   if (list.isNotEmpty) {
  //     // Return true because there is an existing user using the email address
  //     return true;
  //   } else {
  //     // Return false because email address is not in use
  //     return false;
  //   }
  // }

  //todo implement update details
// Update User Details in Firebase and then local storage
  Future<String?> updateUserDetails(User user) async {
    await _auth.currentUser?.updatePhotoURL(user.profilePic);
    await _auth.currentUser?.updateDisplayName(user.name);
    await _auth.currentUser?.updateEmail(user.email);
    // await _auth.currentUser?.updatePassword(newPassword);
    // await _auth.currentUser?.updatePhoneNumber(user.phone);


    return null;
  }

  // returns a list of sign in options for that email address
  Future<String> checkForExistingUser({required email}) async {
    try {
      final message = await _auth.fetchSignInMethodsForEmail(email);
      print('firebase fetch sign in methods $message');
      return message.toString();
    } on auth.FirebaseAuthException catch (e) {
      print(e);
      return e.code;
    }
  }

  Future<String?> linkUserCredential(credential) async {
    try {
      _auth.currentUser?.linkWithCredential(credential);
      return 'sign-in method linked with account';
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
          profilePic: credential.user!.photoURL,
          signUpOption: SignUpOption.emailPassword);
    } on auth.FirebaseAuthException catch (e) {
      print('test');
      print("$e");
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
        profilePic: firebaseUser?.photoURL,
        phone: firebaseUser?.phoneNumber);
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
            profilePic: firebaseUser.photoURL,
            name: firebaseUser.displayName);
      } else {
        final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

        final credential = auth.GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final firebaseUser =
            (await _auth.signInWithCredential(credential)).user;
        return User(
            email: firebaseUser!.email!,
            phone: firebaseUser.phoneNumber,
            profilePic: firebaseUser.photoURL,
            name: firebaseUser.displayName);
      }
    } on auth.FirebaseAuthException {
      rethrow;
      // showSnackBar(context, e.message!); // Displaying the error message
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

      return User(
          email: firebaseUser!.email!,
          phone: firebaseUser.phoneNumber,
          profilePic: facebookUser["picture"]["data"]["url"],
          name: firebaseUser.displayName);

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
              profilePic: firebaseUser.photoURL,
              name: firebaseUser.displayName);

        case TwitterLoginStatus.cancelledByUser:
          print('cancelled by user');
          break;
        case TwitterLoginStatus.error:
          print('twitter login error');
          break;
        default:
          return null;
      }
    } on auth.FirebaseAuthException {
      rethrow;
    }
    return null;
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
  Future<String?> signOut() async {
    try {
      await googleSignIn.signOut();

      _auth.signOut();
      return 'Signed out successfully';
    } on auth.FirebaseAuthException {
      rethrow;
    }
  }
}
