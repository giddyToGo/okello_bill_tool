import "dart:async";

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'package:okello_bill_tool/repositories/firebase_auth_methods.dart';
import 'package:okello_bill_tool/screens/source.dart';

import '../../../dialogs/auth_error.dart';
import '../../../models/user_model.dart';
import '../internet/internet_cubit.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState1> {
  AuthCubit(this.internetCubit)
      : super(AuthState1.initial(User.empty(), AuthError.empty()));

  final log = Logger('ExampleLogger');
  final usersBox = Hive.box("users_box");
  final jsonUser = Hive.box("users_box").get("user");

  AuthRepository authMethods = AuthRepository();

  final InternetCubit internetCubit;

  _handleError(e) {
    print("----------------------------${e.runtimeType}");
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

  /// this function should take the uid from local storage, find the data in Firestore and update
  /// all the local User information to match.
  ///
  void initialiseUser() async {
    emit(AuthState1.loading(state.user, null, 'Initialising user...'));
    log.severe('testing a log ');
    final jsonUser = Hive.box("users_box").get("user");

    if (jsonUser != null) {
      print(
          '-----------jsonUser != null from initialiseUser() user: $jsonUser');
      try {
        final jsonUid = User.fromJson(jsonUser).uid ?? "";
        dynamic fireStoreData = await authMethods.getFireStoreUser(jsonUid);
        print(
            '---------------------------------firestore data from authmethods call in initialiseUser() cubit = $fireStoreData');

        // User newUser = User(email: fireStoreData.email, uid: fireStoreData.uid);

        print('////////////////////////////////////////');
        // print('------ - newUser: $newUser');
        print(
            '----------------------------------------firestoreData from initialiseUser:    $fireStoreData');
      } catch (e) {
        {
          if (e is SocketException) {
            emit(AuthState1.error(state.user, const AuthErrorNoInternet()));
          } else if (e is TimeoutException) {
            emit(AuthState1.error(state.user, const AuthErrorNoInternet()));
          } else if (e is FirebaseAuthException) {
            emit(AuthState1.error(
                state.user,
                AuthError(
                    dialogText: e.message ?? "Initialise User Error",
                    dialogTitle: e.code)));
          } else {
            emit(AuthState1.error(
                state.user,
                AuthError(
                    dialogText: e.toString(),
                    dialogTitle: 'Initialise User Error')));
          }
        }
      }

      emit(AuthState1.success(
          User.fromJson(jsonUser), null, 'Successfully initialised user...'));
    } else {
      emit(AuthState1.error(
          state.user,
          AuthError(
              dialogTitle: 'No user in local storage',
              dialogText: 'Please sign in.')));
      print(
          '----------------jsonUser must be null from initialiseUser function');
    }
  }

  Future<void> updateUserDetails(User user) async {
    emit(AuthState1.loading(user, null, "Updating details"));
    try {
      print('-------------user data at start of updateUserDetails cubit');
      final usersBox = Hive.box("users_box");

      /// remember to turn this back on ------------------------------------------------------------------------------------------------
      // usersBox.put("user", user.toJson());
      final jsonUser = Hive.box("users_box").get("user");
      // await authMethods.updateFirestoreUser(user);   -- delete if everything is sweet
      await authMethods.updateUserDetails(user);

      await usersBox.put("user", user.toJson());

      emit(AuthState1.success(
          User.fromJson(jsonUser), null, "Successfully updated"));
      return;
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
      emit(AuthState1.success(state.user.copyWith(photoURL: newProfilePicURL),
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
    } catch (e) {
      _handleError(e);
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
          'printing user data from firebase Twitter sign in. name: ${user?.name}, profilepic: ${user?.photoURL}');

      await Hive.box("users_box").put("user", user!.toJson());
      emit(AuthState1.content(
          user, null, 'Successfully signed in with twitter'));
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> authSignOut(User user) async {
    emit(AuthState1.loading(state.user, null, 'Signing out'));
    print(
        "---------before delete--------------------${Hive.box("users_box").get("user").toString()}");
    try {
      User signedOutUser = state.user.signOut();
      await Hive.box("users_box").put("user", signedOutUser.toJson());
      await authMethods.signOut();
      await Hive.box("users_box").clear();
      print(
          "--------------------after delete: ${Hive.box("users_box").get("user")}");
      emit(AuthState1.initial(User.empty(), null, 'Successfully signed out'));
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
