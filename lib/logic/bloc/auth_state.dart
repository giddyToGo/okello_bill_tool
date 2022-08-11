part of 'auth_bloc.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final AuthError? authError;
  final String? profilePic;
  final String? email;
  final String? phoneNumber;
  final String? displayName;

  const AuthState({
    required this.isLoading,
    this.authError,
    this.phoneNumber = '',
    this.email = '',
    this.displayName = '',
    this.profilePic = '',
  });
}

@immutable
class AppStateLoggedIn extends AuthState {
  final auth.User user;
  final Iterable<Reference> images;
  final String profilePic;
  final String? email;
  final String? phoneNumber;
  final String? displayName;

  const AppStateLoggedIn({
    required bool isLoading,
    required this.user,
    required this.images,
    this.profilePic = "",
    this.phoneNumber = '',
    this.email = '',
    this.displayName = '',
    AuthError? authError,
  }) : super(
          isLoading: isLoading,
          authError: authError,
          profilePic: profilePic,
        );

  @override
  bool operator ==(other) {
    final otherClass = other;
    if (otherClass is AppStateLoggedIn) {
      return isLoading == otherClass.isLoading &&
          user.uid == otherClass.user.uid &&
          images.length == otherClass.images.length;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(
        user.uid,
        images,
      );

  @override
  String toString() => 'AppStateLoggedIn, images.length = ${images.length}';
}

@immutable
class AppStateLoggedOut extends AuthState {
  const AppStateLoggedOut({
    required bool isLoading,
    AuthError? authError,
  }) : super(
          isLoading: isLoading,
          authError: authError,
        );

  @override
  String toString() =>
      'AppStateLoggedOut, isLoading = $isLoading, authError = $authError';
}

@immutable
class AppStateIsInRegistrationView extends AuthState {
  const AppStateIsInRegistrationView({
    required bool isLoading,
    AuthError? authError,
  }) : super(
          isLoading: isLoading,
          authError: authError,
        );
}

extension GetUser on AuthState {
  auth.User? get user {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.user;
    } else {
      return null;
    }
  }
}

extension GetImages on AuthState {
  Iterable<Reference>? get images {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.images;
    } else {
      return null;
    }
  }
}
