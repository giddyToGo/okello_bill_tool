import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:hive/hive.dart';
import 'package:okello_bill_tool/repositories/firebase_auth_methods.dart';
import 'package:okello_bill_tool/screens/source.dart';

import '../../../dialogs/auth_error.dart';
import '../../../models/user_model.dart';
import 'auth_state.dart';

import "dart:async";

class AuthCubit extends Cubit<AuthState1> {
  AuthCubit()
      : super(AuthState1.initial(User.empty(), const AuthError.empty()));

  final usersBox = Hive.box("users_box");
  final jsonUser = Hive.box("users_box").get("user");

  AuthRepository authMethods = AuthRepository();

  doSth() async {}

  void initialiseFromLocalStorage() {
    final usersBox = Hive.box("users_box");
    final jsonUser = usersBox.get("user");
    final User user = User.fromJson(jsonUser);
    emit(AuthState1.initial(user, null,
        "Found user in local storage. User signed in? ${user.signedIn}"));
  }

  Future<void> updateUserDetails(User user) async {
    final usersBox = Hive.box("users_box");
    usersBox.put("user", user.toJson());
    final jsonUser = Hive.box("users_box").get("user");
    authMethods.updateUserDetails(user);
    emit(AuthState1.success(
        User.fromJson(jsonUser), null, "Successfully updated"));
  }

  Future<void> authUploadImage({required String path}) async {
    final user = state.user;

    try {
      if (user.uid == null) throw 'User not signed in';
      // start the loading process
      emit(AuthState1.loading(state.user, null, "Uploading your picture"));
      // upload the file
      final newProfilePicURL =
          await authMethods.uploadImage(path: path, userId: user.uid);

      // emit the new profile pic and turn off loading
      emit(AuthState1.success(state.user.copyWith(profilePic: newProfilePicURL),
          null, "Successfully uploaded image"));
      updateUserDetails(state.user);
    } catch (e) {
      _handleError(e);
    }
    // log user out if we don't have an actual user in app auth
  }

  _handleError(e) {
    if (e is SocketException) {
      emit(AuthState1.error(state.user, const AuthErrorNoInternet()));
    } else if (e is TimeoutException) {
      emit(AuthState1.error(state.user, const AuthErrorNoInternet()));
    } else if (e is FirebaseAuthException) {
      emit(AuthState1.error(state.user,
          AuthError(dialogText: e.message ?? "Unknown", dialogTitle: e.code)));
    } else {
      emit(AuthState1.error(
          state.user,
          AuthError(
              dialogText: e.toString(), dialogTitle: 'An Error Happened')));
    }
  }

  Future<void> checkForExistingUserInFirebase({required email}) async {
    try {
      emit(AuthState1.loading(state.user, null, 'Checking for a user'));

      bool existingUser = await authMethods.checkForExistingUser(email: email);

      emit(AuthState1.success(
          state.user,
          null,
          existingUser
              ? "A user with this email exists"
              : "No user exists with this email"));

      return;
    } catch (e) {
      _handleError(e);
    }
  }

  bool checkForExistingUserInLocalStorage() {
    final jsonUser = Hive.box("users_box").get("user");
    if (jsonUser != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> authSignIn(
      {required String email, required String password}) async {
    emit(AuthState1.loading(state.user, null, "Signing in..."));
    try {
      final user =
          await authMethods.signInWithEmail(email: email, password: password);
      await Hive.box("users_box").put("user", user!.toJson());
      emit(AuthState1.content(user, null, "Successfully signed in with email"));
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> authSignUp(
      {required String email, required String password}) async {
    emit(AuthState1.loading(state.user, null, "Creating Account"));
    try {
      final user =
          await authMethods.signUpWithEmail(email: email, password: password);
      await Hive.box("users_box").put("user", user!.toJson());
      emit(AuthState1.content(user, null, 'Successfully signed up'));
      return;
    } on SocketException catch (_) {
      emit(AuthState1.error(state.user, const AuthErrorNoInternet()));
    } on TimeoutException catch (_) {
      emit(AuthState1.error(state.user, const AuthErrorNoInternet()));
    } catch (e) {
      emit(AuthState1.error(
          state.user,
          AuthError(
              dialogText: e.toString(), dialogTitle: 'An Error Happened')));
    }
  }

  Future<void> authSignInWithGoogle() async {
    emit(AuthState1.loading(state.user, null, "Signing in with Google"));
    try {
      final User? user = await authMethods.signInWithGoogle();
      await Hive.box("users_box").put("user", user!.toJson());
      final jsonUser = Hive.box("users_box").get("user");
      emit(
          AuthState1.content(user, null, 'Successfully signed in with Google'));
    } catch (e) {
      emit(AuthState1.error(
          state.user,
          AuthError(
              dialogText: e.toString(), dialogTitle: 'An Error Happened')));
    }
  }

  Future<void> authSignInWithFacebook() async {
    emit(AuthState1.loading(state.user, null, "Signing in with Facebook"));
    try {
      final user = await authMethods.signInWithFacebook();
      await Hive.box("users_box").put("user", user!.toJson());
      emit(AuthState1.content(
          user, null, 'Successfully signed in with Facebook'));
    } catch (e) {
      emit(AuthState1.error(
          state.user,
          AuthError(
              dialogText: e.toString(), dialogTitle: 'An Error Happened')));
    }
  }

  Future<void> authSignInWithTwitter() async {
    emit(AuthState1.loading(state.user, null, "Signing in with Twitter"));
    try {
      final user = await authMethods.signInWithTwitter();
      print(
          'printing user data from firebase Twitter sign in. name: ${user?.name}, profilepic: ${user?.profilePic}');

      await Hive.box("users_box").put("user", user!.toJson());
      emit(AuthState1.content(
          user, null, 'Successfully signed in with twitter'));
    } catch (e) {
      emit(AuthState1.error(
          state.user,
          AuthError(
              dialogText: e.toString(), dialogTitle: 'An Error Happened')));
    }
  }

  Future<void> authSignOut(User user) async {
    emit(AuthState1.loading(state.user, null, 'Signing out'));
    try {
      User signedOutUser = state.user.signOut();
      await Hive.box("users_box").put("user", signedOutUser.toJson());
      await authMethods.signOut();
      emit(AuthState1.initial(signedOutUser, null, 'Successfully signed out'));
    } catch (e) {
      emit(AuthState1.error(
          state.user,
          AuthError(
              dialogText: e.toString(), dialogTitle: 'An Error Happened')));
    }
  }

  Future<void> authDeleteAccount() async {
    emit(AuthState1.loading(state.user, null, 'Deleting account'));
    try {
      await authMethods.deleteUser();
      emit(AuthState1.initial(
          User.empty(), null, 'Successfully deleted account'));
      return;
    } catch (e) {
      emit(AuthState1.error(
          state.user,
          AuthError(
              dialogText: e.toString(), dialogTitle: 'An Error Happened')));
      return;
    }
  }

  Future<void> authResetPassword({required email}) async {
    emit(AuthState1.loading(state.user));
    try {
      await authMethods.forgottenPassword(email: email);
      emit(AuthState1.initial(User.empty(), null, 'Password reset link sent'));
      return;
    } catch (e) {
      emit(AuthState1.error(
          state.user,
          AuthError(
              dialogText: e.toString(), dialogTitle: 'An Error Happened')));
    }
  }
}
