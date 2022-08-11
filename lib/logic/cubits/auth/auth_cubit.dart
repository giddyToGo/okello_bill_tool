import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive/hive.dart';
import 'package:okello_bill_tool/repositories/firebase_auth_methods.dart';
import 'package:okello_bill_tool/screens/source.dart';

import '../../../dialogs/auth_error.dart';
import '../../../models/user_model.dart';
import '../../../utils/upload_image.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState1> {
  AuthCubit() : super(AuthState1.initial(User.empty(), AuthError.empty()));

  AuthRepository authMethods = AuthRepository();

  Future<String> updateUserDetails(User user) async {
    try {
      final usersBox = Hive.box("users_box");
      usersBox.put("user", user.toJson());
      final jsonUser = Hive.box("users_box").get("user");
      emit(AuthState1.userUpdated(User.fromJson(jsonUser)));
      print(
          'testing the output of user from UpdateUerDetails, auth cubit: $jsonUser');

      return 'finished';
    } catch (e) {
      return 'error occurred whilst updating user details: $e';
    }
  }

  Future<String> checkForExistingUser({required email}) async {
    final message = await authMethods.checkForExistingUser(email: email);
    return message.toString();
  }

  void checkIfUserExistsInLocalStorage() {
    final jsonUser = Hive.box("users_box").get("user");
    print("JSON user from checkIf UserIsSignedInLocalStorage: $jsonUser");
    if (jsonUser != null) {
      emit(AuthState1.content(User.fromJson(jsonUser)));
    }
  }

  //
  // void checkIfUserIsSignedIn(state) {
  //   final jsonUser = Hive.box("users_box").get("user");
  //   print("JSON user from checkIf UserIsSignedIn: $jsonUser");
  //   if (jsonUser != null) {
  //     emit(AuthState1.content(User.fromJson(jsonUser)));
  //   }
  // }

  Future<String> authSignIn(
      {required String email, required String password}) async {
    emit(AuthState1.loading(state.user));
    try {
      final user =
          await authMethods.signInWithEmail(email: email, password: password);
      await Hive.box("users_box").put("user", user!.toJson());
      emit(AuthState1.content(user));
      return "successfully signed in with email";
    } on FirebaseAuthException catch (e) {
      emit(AuthState1.error(
          state.user,
          AuthError(
              dialogText: e.message ?? "Unknown",
              dialogTitle: 'An Error Happened')));
      return e.message ?? "unknown error occurred";
    } catch (e) {
      emit(AuthState1.error(
          state.user,
          AuthError(
              dialogText: e.toString(), dialogTitle: 'An Error Happened')));
      return " error not coming from firebase: ${e.toString()}";
    }
  }

  Future<String> authSignUp(
      {required String email, required String password}) async {
    emit(AuthState1.loading(state.user));
    try {
      final user =
          await authMethods.signUpWithEmail(email: email, password: password);
      await Hive.box("users_box").put("user", user!.toJson());
      emit(AuthState1.content(user));
      return 'successfully signed up';
    } catch (e) {
      emit(AuthState1.error(
          state.user,
          AuthError(
              dialogText: e.toString(), dialogTitle: 'An Error Happened')));
      return e.toString();
    }
  }

  Future<String> authSignInWithGoogle() async {
    emit(AuthState1.loading(state.user));
    try {
      final User? user = await authMethods.signInWithGoogle();
      await Hive.box("users_box").put("user", user!.toJson());
      final jsonUser = Hive.box("users_box").get("user");
      log("JSON user from googleSignin After success: $jsonUser");
      log("JSON user from googleSignin After success from json:)}");
      emit(AuthState1.content(user));
      return 'successfully signed in with google';
    } catch (e) {
      emit(AuthState1.error(
          state.user,
          AuthError(
              dialogText: e.toString(), dialogTitle: 'An Error Happened')));
      return e.toString();
    }
  }

  Future<String> authSignInWithFacebook() async {
    emit(AuthState1.loading(state.user));
    try {
      final user = await authMethods.signInWithFacebook();
      await Hive.box("users_box").put("user", user!.toJson());
      emit(AuthState1.content(user));
      return 'succesfully signed in with facebook';
    } catch (e) {
      emit(AuthState1.error(
          state.user,
          AuthError(
              dialogText: e.toString(), dialogTitle: 'An Error Happened')));
      return e.toString();
    }
  }

  Future<String> authSignInWithTwitter() async {
    emit(AuthState1.loading(state.user));
    try {
      final user = await authMethods.signInWithTwitter();
      await Hive.box("users_box").put("user", user!.toJson());
      emit(AuthState1.content(user));
      return 'successfully signed in with twitter';
    } catch (e) {
      emit(AuthState1.error(
          state.user,
          AuthError(
              dialogText: e.toString(), dialogTitle: 'An Error Happened')));
      return e.toString();
    }
  }

  Future<String> authSignOut() async {
    emit(AuthState1.loading(state.user));
    try {
      await authMethods.signOut();
      emit(AuthState1.initial(
          User.empty(), const AuthError(dialogTitle: '', dialogText: '')));
      return 'successfully signed out';
    } catch (e) {
      emit(AuthState1.error(
          state.user,
          AuthError(
              dialogText: e.toString(), dialogTitle: 'An Error Happened')));
      return e.toString();
    }
  }

  Future<String> authDeleteAccount() async {
    emit(AuthState1.loading(state.user));
    try {
      await authMethods.deleteUser();
      emit(AuthState1.initial(User.empty()));
      return 'successfully deleted account';
    } catch (e) {
      emit(AuthState1.error(
          state.user,
          AuthError(
              dialogText: e.toString(), dialogTitle: 'An Error Happened')));
      return e.toString();
    }
  }

  Future<String> authResetPassword({required email}) async {
    emit(AuthState1.loading(state.user));
    try {
      await authMethods.forgottenPassword(email: email);
      emit(AuthState1.initial(User.empty()));
      return 'password reset link sent';
    } catch (e) {
      emit(AuthState1.error(
          state.user,
          AuthError(
              dialogText: e.toString(), dialogTitle: 'An Error Happened')));
      return e.toString();
    }
  }

  Future<void> authUploadImage({required String path}) async {
    final user = state.user;

    try {
      if (user.uid == null) throw 'user not signed in';
      // start the loading process
      emit(AuthState1.loading(state.user));
      // upload the file
      final newProfilePicURL =
          await authMethods.uploadImage(path: path, userId: user.uid!);
      //
      // after upload is complete, grab the latest file references
      // final images = await _getImages(user.uid ?? '');

      // emit the new profile pic and turn off loading
      emit(AuthState1.userUpdated(
          state.user.copyWith(profilePic: newProfilePicURL)));
    } catch (e) {
      emit(AuthState1.error(
          state.user,
          AuthError(
              dialogText: e.toString(), dialogTitle: 'An Error Happened')));
    }
    // log user out if we don't have an actual user in app auth
  }
}
