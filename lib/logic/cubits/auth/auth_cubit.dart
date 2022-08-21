import "dart:async";

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:hive/hive.dart';
import 'package:okello_bill_tool/repositories/firebase_auth_methods.dart';
import 'package:okello_bill_tool/screens/source.dart';

import '../../../dialogs/auth_error.dart';
import '../../../models/user_model.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState1> {
  AuthCubit()
      : super(AuthState1.initial(User.empty(), const AuthError.empty()));

  final usersBox = Hive.box("users_box");
  final jsonUser = Hive.box("users_box").get("user");

  AuthRepository authMethods = AuthRepository();

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

  void initialiseFromLocalStorage() {
    print(
        'initialiseFromLocalStorage: about to emit loading state from initialiseFromLocalStorage');
    emit(AuthState1.loading(
        state.user, null, 'initialising from local storage...'));
    final usersBox = Hive.box("users_box");
    final jsonUser = usersBox.get("user");
    final User user = User.fromJson(jsonUser);

    if (user.signedIn == true) {
      emit(AuthState1.content(user, null,
          "Found user in local storage. User signed in? ${user.signedIn}"));
    } else if (user.signedIn == false) {
      emit(AuthState1.initial(user, null,
          "Found user in local storage. User signed in? ${user.signedIn}"));
    } else {
      emit(AuthState1.initial(user, null,
          "found user in local storage user signed in = null probably"));
    }
    print(
        'initialiseFromLocalStorage: state after initialise from local signedIn? selection ${state.toString()}');
  }

  Future<void> updateUserDetails(User user) async {
    try {
      final usersBox = Hive.box("users_box");
      usersBox.put("user", user.toJson());
      final jsonUser = Hive.box("users_box").get("user");
      authMethods.updateFirestoreUser(user);
      authMethods.updateUserDetails(user);
      emit(AuthState1.success(
          User.fromJson(jsonUser), null, "Successfully updated"));
    } catch (e) {
      _handleError(e);
    }
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
    initialiseFromLocalStorage();
    emit(AuthState1.loading(state.user, null, "Signing in..."));
    try {
      print('authSignIn: auth Sign in doing something');
      final user =
          await authMethods.signInWithEmail(email: email, password: password);
      await Hive.box("users_box").put("user", user!.toJson());
      emit(AuthState1.content(user, null, "Successfully signed in with email"));
      print('print this after content state emitted from authSignIn');
      print(
          'authSignIn: state after content emitted from authSignIn: ${state.toString()}, signedIn = ${state.user.signedIn}');
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> authSignUp(
      {required String email, required String password}) async {
    print('authSignUp: about to emit loading state');
    emit(AuthState1.loading(state.user, null, "Creating Account"));
    try {
      final user =
          await authMethods.signUpWithEmail(email: email, password: password);
      await Hive.box("users_box").put("user", user!.toJson());
      emit(AuthState1.content(user, null, 'Successfully signed up'));
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> authSignInWithGoogle() async {
    emit(AuthState1.loading(state.user, null, "Signing in with Google"));
    try {
      final User? user = await authMethods.signInWithGoogle();
      await Hive.box("users_box").put("user", user!.toJson());

      emit(
          AuthState1.content(user, null, 'Successfully signed in with Google'));
      print("------------------------------------------------------");
      print("emitted the content state after signing in");
      print('state after emitted ${state.toString()}');

      print("------------------------------------------------------");
    } catch (e) {
      _handleError(e);
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
      _handleError(e);
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
      _handleError(e);
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
      _handleError(e);
    }
  }

  Future<void> authDeleteAccount() async {
    emit(AuthState1.loading(state.user, null, 'Deleting account'));
    try {
      await authMethods.deleteUser();
      emit(AuthState1.initial(
          User.empty(), null, 'Successfully deleted account'));
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> authResetPassword({required email}) async {
    emit(AuthState1.loading(state.user));
    try {
      await authMethods.forgottenPassword(email: email);
      emit(AuthState1.initial(User.empty(), null, 'Password reset link sent'));
    } catch (e) {
      _handleError(e);
    }
  }
}
