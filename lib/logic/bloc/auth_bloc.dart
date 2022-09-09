import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show immutable, kIsWeb;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:okello_bill_tool/dialogs/auth_error.dart';
import 'package:twitter_login/twitter_login.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc()
      : super(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        ) {
    final _googleSignIn = GoogleSignIn();
    final _auth = auth.FirebaseAuth.instance;

    on<AppEventGoToRegistration>((event, emit) {
      emit(
        const AppStateIsInRegistrationView(
          isLoading: false,
        ),
      );
    });
    on<AppEventLogInWithEmailAndPassword>(
      (event, emit) async {
        emit(
          const AppStateLoggedOut(
            isLoading: true,
          ),
        );
        // log the user in
        try {
          final email = event.email;
          final password = event.password;
          final userCredential = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          // get images for user
          final user = userCredential.user!;
          final images = await _getImages(user.uid);
          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: user,
              images: images,
            ),
          );
        } on auth.FirebaseAuthException catch (e) {
          emit(
            AppStateLoggedOut(
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );

    on<AppEventLogInWithGoogle>(
      (event, emit) async {
        emit(
          const AppStateLoggedOut(
            isLoading: true,
          ),
        );
        // log the user in
        try {
          if (kIsWeb) {
            var googleProvider = auth.GoogleAuthProvider();
            googleProvider
                .addScope('https://www.googleapis.com/auth/contacts.readonly');
            await _auth.signInWithPopup(googleProvider);
          } else {
            final GoogleSignInAccount? googleSignInAccount =
                await _googleSignIn.signIn();

            final GoogleSignInAuthentication googleSignInAuthentication =
                await googleSignInAccount!.authentication;

            final userCredential = auth.GoogleAuthProvider.credential(
              accessToken: googleSignInAuthentication.accessToken,
              idToken: googleSignInAuthentication.idToken,
            );
            final credential = await _auth.signInWithCredential(userCredential);
            // get images for user
            final user = credential.user;
            if (user != null) {
              final images = await _getImages(user.uid);
              final photoUrl = user.photoURL;
              final displayName = user.displayName;
              final email = user.email;
              final phoneNumber = user.phoneNumber;

              emit(
                AppStateLoggedIn(
                  isLoading: false,
                  user: user,
                  images: images,
                  profilePic: photoUrl ?? '',
                  displayName: displayName ?? '',
                  email: email ?? '',
                  phoneNumber: phoneNumber ?? '',
                ),
              );
            }
          }
        } on auth.FirebaseAuthException catch (e) {
          emit(
            AppStateLoggedOut(
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );

    on<AppEventLogInWithFacebook>(
      (event, emit) async {
        emit(
          const AppStateLoggedOut(
            isLoading: true,
          ),
        );
        // log the user in
        try {
          // final userCredential = await _auth.signInWithEmailAndPassword();
          final LoginResult loginResult = await FacebookAuth.instance.login();

          final credential = auth.FacebookAuthProvider.credential(
              loginResult.accessToken!.token);

          final firebaseUser =
              (await _auth.signInWithCredential(credential)).user;

          //get userData from facebook (Map<String dynamic>) email, id, name, picture
          final facebookUserData = await FacebookAuth.instance.getUserData();

          if (firebaseUser != null) {
            final String accessToken = credential.accessToken!;
            final images = await _getImages(firebaseUser.uid);
            final String photoUrl = facebookUserData["picture"]["data"]["url"];

            final String displayName = facebookUserData["name"];
            final String email = facebookUserData["email"];
            final phoneNumber = firebaseUser.phoneNumber;

            emit(
              AppStateLoggedIn(
                isLoading: false,
                user: firebaseUser,
                images: images,
                profilePic: facebookUserData["picture"]["data"]["url"],
                displayName: displayName,
                email: email,
                phoneNumber: phoneNumber ?? '',
              ),
            );
          }
        } on auth.FirebaseAuthException catch (e) {
          emit(
            AppStateLoggedOut(
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );

    on<AppEventLogInWithTwitter>(
      (event, emit) async {
        emit(
          const AppStateLoggedOut(
            isLoading: true,
          ),
        );
        // log the user in
        try {
          final twitterLogin = TwitterLogin(
              apiKey: "b6AOYlId3dXgDU62Q2PGE6qGP",
              apiSecretKey:
                  "ZNUfPAR2hEmNiUDh357N9nzYt3toMzjEYbWon44E6tIC66OBzX",
              redirectURI: "okello-billtool://");

          final authResult = await twitterLogin.loginV2();

          final twitterAuthCredential = auth.TwitterAuthProvider.credential(
              accessToken: authResult.authToken!,
              secret: authResult.authTokenSecret!);

          final userCred =
              await _auth.signInWithCredential(twitterAuthCredential);
          final user = userCred.user;

          if (user != null) {
            final String photoUrl = user.photoURL ?? "";
            final images = await _getImages(user.uid);
            final String displayName = user.displayName ?? "";
            final String email = user.email ?? "";
            final phoneNumber = user.phoneNumber ?? "";

            emit(
              AppStateLoggedIn(
                isLoading: false,
                user: user,
                images: images,
                profilePic: photoUrl,
                displayName: displayName,
                email: email,
                phoneNumber: phoneNumber,
              ),
            );
          }
        } on auth.FirebaseAuthException catch (e) {
          emit(
            AppStateLoggedOut(
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );

    on<AppEventGoToLogin>(
      (event, emit) {
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      },
    );
    on<AppEventRegister>(
      (event, emit) async {
        // start loading
        emit(
          const AppStateIsInRegistrationView(
            isLoading: true,
          ),
        );
        final email = event.email;
        final password = event.password;
        try {
          // create the user
          final credentials = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: credentials.user!,
              images: const [],
            ),
          );
        } on auth.FirebaseAuthException catch (e) {
          emit(
            AppStateIsInRegistrationView(
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        }
      },
    );
    on<AppEventInitialize>(
      (event, emit) async {
        // get the current user
        final user = _auth.currentUser;
        if (user == null) {
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
        } else {
          // go grab the user's uploaded images
          final images = await _getImages(user.uid);
          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: user,
              images: images,
            ),
          );
        }
      },
    );
    // log out event
    on<AppEventLogOut>(
      (event, emit) async {
        // start loading
        emit(
          const AppStateLoggedOut(
            isLoading: true,
          ),
        );

        // log the user out
        try {
          if (_auth.currentUser != null &&
              _auth.currentUser?.providerData[0].providerId == 'google.com') {
            await _googleSignIn.disconnect();
            emit(
              const AppStateLoggedOut(
                isLoading: false,
              ),
            );
          } else {
            await _auth.signOut();
            // log the user out in the UI as well
            emit(
              const AppStateLoggedOut(
                isLoading: false,
              ),
            );
          }
        } catch (e) {
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
          rethrow;
        }
      },
    );
    // handle account deletion
    on<AppEventDeleteAccount>(
      (event, emit) async {
        final user = _auth.currentUser;
        // log the user out if we don't have a current user
        if (user == null) {
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
          return;
        }
        // start loading
        emit(
          AppStateLoggedIn(
            isLoading: true,
            user: user,
            images: state.images ?? [],
          ),
        );
        // delete the user folder
        try {
          // delete user folder
          final folderContents =
              await FirebaseStorage.instance.ref(user.uid).listAll();
          for (final item in folderContents.items) {
            await item.delete().catchError((_) {}); // maybe handle the error?
          }
          // delete the folder itself
          await FirebaseStorage.instance
              .ref(user.uid)
              .delete()
              .catchError((_) {});

          // delete the user
          await user.delete();
          // log the user out
          await _auth.signOut();
          // log the user out in the UI as well
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
        } on auth.FirebaseAuthException catch (e) {
          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: user,
              images: state.images ?? [],
              authError: AuthError.from(e),
            ),
          );
        } on FirebaseException {
          // we might not be able to delete the folder
          // log the user out
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
        }
      },
    );

    // handle uploading images
    on<AppEventUploadImage>(
      (event, emit) async {
        final user = state.user;
        // log user out if we don't have an actual user in app auth
        if (user == null) {
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
          return;
        }
        // start the loading process
        emit(
          AppStateLoggedIn(
            isLoading: true,
            user: user,
            images: state.images ?? [],
          ),
        );
        // upload the file
        final file = File(event.filePathToUpload);
        /*   await authMethods.uploadImage(
          file: file,
          userId: user.uid,
        );*/
        // after upload is complete, grab the latest file references
        final images = await _getImages(user.uid);
        // emit the new images and turn off loading
        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: user,
            images: images,
          ),
        );
      },
    );
  }

  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance
          .ref(userId)
          .list()
          .then((listResult) => listResult.items);
}
