import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../dialogs/auth_error.dart';
import '../../../models/user_model.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState1 with _$AuthState1 {
  const factory AuthState1.loading(User user, [AuthError? authError]) =
  _Loading;

  const factory AuthState1.content(User user, [AuthError? authError]) =
  _Content;

  const factory AuthState1.error(User user, AuthError authError) = _Error;

  const factory AuthState1.initial(User user, [AuthError? authError]) =
  _Initial;

  const factory AuthState1.userUpdated(User user, [AuthError? authError]) =
  _UserUpdated;

}
