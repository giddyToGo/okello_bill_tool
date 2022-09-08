import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../dialogs/auth_error.dart';
import '../../../models/user_model.dart';

part 'auth_state.freezed.dart';

// enum Action {
//   signIn,
//   signOut,
//   forgotPassword,
//   navigate,
//   updateProfilePicture,
//   saveDetails,
// }

@freezed
class AuthState1 with _$AuthState1 {
  const factory AuthState1.loading(User user,
      [AuthError? authError, String? message]) = _Loading;

  const factory AuthState1.error(User user, AuthError authError,
      [bool? showError]) = _Error;

  const factory AuthState1.initial(User user,
      [AuthError? authError, String? message]) = _Initial;

  const factory AuthState1.content(User user,
      [AuthError? authError, String? message]) = _Content;

  const factory AuthState1.success(User user,
      [AuthError? authError, String? message]) = _Success;
}
