part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

@immutable
class AppEventUploadImage implements AuthEvent {
  final String filePathToUpload;

  const AppEventUploadImage({
    required this.filePathToUpload,
  });
}

@immutable
class AppEventDeleteAccount implements AuthEvent {
  const AppEventDeleteAccount();
}

@immutable
class AppEventLogOut implements AuthEvent {
  const AppEventLogOut();
}

@immutable
class AppEventInitialize implements AuthEvent {
  const AppEventInitialize();
}

@immutable
class AppEventLogInWithEmailAndPassword implements AuthEvent {
  final String email;
  final String password;

  const AppEventLogInWithEmailAndPassword({
    required this.email,
    required this.password,
  });
}

@immutable
class AppEventLogInWithGoogle implements AuthEvent {
  const AppEventLogInWithGoogle();
}

@immutable
class AppEventLogInWithFacebook implements AuthEvent {
  const AppEventLogInWithFacebook();
}

@immutable
class AppEventLogInWithTwitter implements AuthEvent {
  const AppEventLogInWithTwitter();
}

@immutable
class AppEventGoToRegistration implements AuthEvent {
  const AppEventGoToRegistration();
}

@immutable
class AppEventGoToLogin implements AuthEvent {
  const AppEventGoToLogin();
}

@immutable
class AppEventRegister implements AuthEvent {
  final String email;
  final String password;

  const AppEventRegister({
    required this.email,
    required this.password,
  });
}
