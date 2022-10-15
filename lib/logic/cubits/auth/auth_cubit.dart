import "dart:async";
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:hive/hive.dart';
import 'package:okello_bill_tool/logic/cubits/internet/internet_cubit.dart';
import 'package:okello_bill_tool/repositories/firebase_auth_methods.dart';
import 'package:okello_bill_tool/screens/source.dart';

import '../../../dialogs/auth_error.dart';
import '../../../models/user_model.dart';
import '../internet/internet_cubit.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState1> {
  AuthCubit(this.internetCubit)
      : super(AuthState1.initial(User.empty(), AuthError.empty()));

  final usersBox = Hive.box("users_box");
  final jsonUser = Hive.box("users_box").get("user");

  AuthRepository authMethods = AuthRepository();

  final InternetCubit internetCubit;

  _handleError(e) {
    logger.e(" Runtime Type: ${e.runtimeType},  toString: ${e.toString()}");

    if (e is PlatformException) {
      if (e.code == "network_error") {
        internetCubit.emitInternetDisconnected();
        emit(AuthState1.error(state.user, const AuthErrorNoInternet(), false));
      }
    } else if (e is SocketException) {
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

  void initialiseUser(User user) async => emit(AuthState1.success(user));

  Future<void> updateUserDetails(User user) async {
    emit(AuthState1.loading(state.user, null, "Updating details"));

    try {
      if (internetCubit.state.toString() == InternetDisconnected().toString()) {
        emit(AuthState1.success(
            user, null, "No internet, changes will update later"));
        await authMethods.updateUserDetails(user);
        await Hive.box("users_box").put("user", user.toJson());
        emit(AuthState1.success(
            user, null, "Reconnected, changes will be updated online."));
      } else {
        await authMethods.updateUserDetails(user);
        await Hive.box("users_box").put("user", user.toJson());
        emit(AuthState1.success(user, null, "Successfully updated"));
        return;
      }
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> authUploadFile({required String path}) async {
    final user = state.user;
    emit(AuthState1.loading(state.user, null, "Uploading your picture"));

    try {
      if (user.uid == null) throw 'User not signed in';
      if (internetCubit.state.toString() == InternetDisconnected().toString()) {
        emit(AuthState1.success(
            user, null, "No internet, changes will update later"));
        final newFilePathURL =
            await authMethods.uploadFile(path: path, userId: user.uid);

        emit(
            AuthState1.success(state.user, null, "Successfully uploaded file"));
        updateUserDetails(state.user);
      } else {
        // upload the file
        final newProfilePicURL =
            await authMethods.uploadFile(path: path, userId: user.uid);

        // emit the new profile pic and turn off loading
        emit(AuthState1.success(state.user.copyWith(photoURL: newProfilePicURL),
            null, "Successfully uploaded image"));
        updateUserDetails(state.user);
      }
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> authUploadImage({required String path}) async {
    final user = state.user;
    emit(AuthState1.loading(state.user, null, "Uploading your picture"));

    try {
      if (user.uid == null) throw 'User not signed in';
      if (internetCubit.state.toString() == InternetDisconnected().toString()) {
        emit(AuthState1.success(
            user, null, "No internet, changes will update later"));
        final newProfilePicURL =
            await authMethods.uploadFile(path: path, userId: user.uid);

        emit(AuthState1.success(state.user.copyWith(photoURL: newProfilePicURL),
            null, "Successfully uploaded image"));
        updateUserDetails(state.user);
      } else {
        // upload the file
        final newProfilePicURL =
            await authMethods.uploadFile(path: path, userId: user.uid);

        // emit the new profile pic and turn off loading
        emit(AuthState1.success(state.user.copyWith(photoURL: newProfilePicURL),
            null, "Successfully uploaded image"));
        updateUserDetails(state.user);
      }
    } catch (e) {
      _handleError(e);
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
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> signInDataFlow(
      {required User? user, required String provider}) async {
    Map<String, dynamic>? firestoreUser =
        await authMethods.getFireStoreUser(user?.uid);
    if (firestoreUser?["uid"] != null) {
      User newUser = User.fromJson(jsonEncode(firestoreUser));
      await Hive.box("users_box").put("user", newUser.toJson());
      emit(AuthState1.content(
          newUser, null, 'Successfully signed in with $provider'));
    } else {
      await Hive.box("users_box").put("user", user!.toJson());
      emit(AuthState1.content(
          user, null, 'Successfully signed in with $provider'));
    }
  }

  Future<void> authSignIn(
      {required String email, required String password}) async {
    emit(AuthState1.loading(state.user, null, "Signing in..."));
    try {
      final user =
          await authMethods.signInWithEmail(email: email, password: password);
      await Hive.box("users_box").put("user", user!.toJson());

      signInDataFlow(user: user, provider: "Email");
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

      signInDataFlow(user: user, provider: "Email");
    } catch (e) {
      _handleError(e);
    }
  }

// todo update Firestore user with user details
  Future<void> authSignInWithGoogle() async {
    emit(AuthState1.loading(state.user, null, "Signing in with Google"));
    try {
      final User? user = await authMethods.signInWithGoogle();
      Hive.box('users_box').put("user", user?.toJson());

      signInDataFlow(user: user, provider: "Google");
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> authSignInWithFacebook() async {
    emit(AuthState1.loading(state.user, null, "Signing in with Facebook"));
    try {
      final user = await authMethods.signInWithFacebook();
      signInDataFlow(user: user, provider: "Facebook");
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> authSignInWithTwitter() async {
    emit(AuthState1.loading(state.user, null, "Signing in with Twitter"));
    try {
      final user = await authMethods.signInWithTwitter();
      await Hive.box("users_box").put("user", user!.toJson());
      signInDataFlow(user: user, provider: "Twitter");
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
      await Hive.box("users_box").clear();
      emit(AuthState1.initial(User.empty(), null, 'Successfully signed out'));
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> authDeleteAccount() async {
    emit(AuthState1.loading(state.user, null, 'Deleting account'));
    try {
      await authMethods.deleteUser();
      await Hive.box("users_box").clear();
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
