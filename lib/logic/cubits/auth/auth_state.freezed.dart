// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AuthState1 {
  User get user => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(User user, AuthError? authError) loading,
    required TResult Function(User user, AuthError? authError) content,
    required TResult Function(User user, AuthError authError) error,
    required TResult Function(User user, AuthError? authError) initial,
    required TResult Function(User user, AuthError? authError) userUpdated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(User user, AuthError? authError)? loading,
    TResult Function(User user, AuthError? authError)? content,
    TResult Function(User user, AuthError authError)? error,
    TResult Function(User user, AuthError? authError)? initial,
    TResult Function(User user, AuthError? authError)? userUpdated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(User user, AuthError? authError)? loading,
    TResult Function(User user, AuthError? authError)? content,
    TResult Function(User user, AuthError authError)? error,
    TResult Function(User user, AuthError? authError)? initial,
    TResult Function(User user, AuthError? authError)? userUpdated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Loading value) loading,
    required TResult Function(_Content value) content,
    required TResult Function(_Error value) error,
    required TResult Function(_Initial value) initial,
    required TResult Function(_UserUpdated value) userUpdated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Loading value)? loading,
    TResult Function(_Content value)? content,
    TResult Function(_Error value)? error,
    TResult Function(_Initial value)? initial,
    TResult Function(_UserUpdated value)? userUpdated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Loading value)? loading,
    TResult Function(_Content value)? content,
    TResult Function(_Error value)? error,
    TResult Function(_Initial value)? initial,
    TResult Function(_UserUpdated value)? userUpdated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AuthState1CopyWith<AuthState1> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthState1CopyWith<$Res> {
  factory $AuthState1CopyWith(
          AuthState1 value, $Res Function(AuthState1) then) =
      _$AuthState1CopyWithImpl<$Res>;
  $Res call({User user});
}

/// @nodoc
class _$AuthState1CopyWithImpl<$Res> implements $AuthState1CopyWith<$Res> {
  _$AuthState1CopyWithImpl(this._value, this._then);

  final AuthState1 _value;
  // ignore: unused_field
  final $Res Function(AuthState1) _then;

  @override
  $Res call({
    Object? user = freezed,
  }) {
    return _then(_value.copyWith(
      user: user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
    ));
  }
}

/// @nodoc
abstract class _$$_LoadingCopyWith<$Res> implements $AuthState1CopyWith<$Res> {
  factory _$$_LoadingCopyWith(
          _$_Loading value, $Res Function(_$_Loading) then) =
      __$$_LoadingCopyWithImpl<$Res>;
  @override
  $Res call({User user, AuthError? authError});
}

/// @nodoc
class __$$_LoadingCopyWithImpl<$Res> extends _$AuthState1CopyWithImpl<$Res>
    implements _$$_LoadingCopyWith<$Res> {
  __$$_LoadingCopyWithImpl(_$_Loading _value, $Res Function(_$_Loading) _then)
      : super(_value, (v) => _then(v as _$_Loading));

  @override
  _$_Loading get _value => super._value as _$_Loading;

  @override
  $Res call({
    Object? user = freezed,
    Object? authError = freezed,
  }) {
    return _then(_$_Loading(
      user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      authError == freezed
          ? _value.authError
          : authError // ignore: cast_nullable_to_non_nullable
              as AuthError?,
    ));
  }
}

/// @nodoc

class _$_Loading implements _Loading {
  const _$_Loading(this.user, [this.authError]);

  @override
  final User user;
  @override
  final AuthError? authError;

  @override
  String toString() {
    return 'AuthState1.loading(user: $user, authError: $authError)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Loading &&
            const DeepCollectionEquality().equals(other.user, user) &&
            const DeepCollectionEquality().equals(other.authError, authError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(user),
      const DeepCollectionEquality().hash(authError));

  @JsonKey(ignore: true)
  @override
  _$$_LoadingCopyWith<_$_Loading> get copyWith =>
      __$$_LoadingCopyWithImpl<_$_Loading>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(User user, AuthError? authError) loading,
    required TResult Function(User user, AuthError? authError) content,
    required TResult Function(User user, AuthError authError) error,
    required TResult Function(User user, AuthError? authError) initial,
    required TResult Function(User user, AuthError? authError) userUpdated,
  }) {
    return loading(user, authError);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(User user, AuthError? authError)? loading,
    TResult Function(User user, AuthError? authError)? content,
    TResult Function(User user, AuthError authError)? error,
    TResult Function(User user, AuthError? authError)? initial,
    TResult Function(User user, AuthError? authError)? userUpdated,
  }) {
    return loading?.call(user, authError);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(User user, AuthError? authError)? loading,
    TResult Function(User user, AuthError? authError)? content,
    TResult Function(User user, AuthError authError)? error,
    TResult Function(User user, AuthError? authError)? initial,
    TResult Function(User user, AuthError? authError)? userUpdated,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(user, authError);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Loading value) loading,
    required TResult Function(_Content value) content,
    required TResult Function(_Error value) error,
    required TResult Function(_Initial value) initial,
    required TResult Function(_UserUpdated value) userUpdated,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Loading value)? loading,
    TResult Function(_Content value)? content,
    TResult Function(_Error value)? error,
    TResult Function(_Initial value)? initial,
    TResult Function(_UserUpdated value)? userUpdated,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Loading value)? loading,
    TResult Function(_Content value)? content,
    TResult Function(_Error value)? error,
    TResult Function(_Initial value)? initial,
    TResult Function(_UserUpdated value)? userUpdated,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements AuthState1 {
  const factory _Loading(final User user, [final AuthError? authError]) =
      _$_Loading;

  @override
  User get user;
  AuthError? get authError;
  @override
  @JsonKey(ignore: true)
  _$$_LoadingCopyWith<_$_Loading> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_ContentCopyWith<$Res> implements $AuthState1CopyWith<$Res> {
  factory _$$_ContentCopyWith(
          _$_Content value, $Res Function(_$_Content) then) =
      __$$_ContentCopyWithImpl<$Res>;
  @override
  $Res call({User user, AuthError? authError});
}

/// @nodoc
class __$$_ContentCopyWithImpl<$Res> extends _$AuthState1CopyWithImpl<$Res>
    implements _$$_ContentCopyWith<$Res> {
  __$$_ContentCopyWithImpl(_$_Content _value, $Res Function(_$_Content) _then)
      : super(_value, (v) => _then(v as _$_Content));

  @override
  _$_Content get _value => super._value as _$_Content;

  @override
  $Res call({
    Object? user = freezed,
    Object? authError = freezed,
  }) {
    return _then(_$_Content(
      user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      authError == freezed
          ? _value.authError
          : authError // ignore: cast_nullable_to_non_nullable
              as AuthError?,
    ));
  }
}

/// @nodoc

class _$_Content implements _Content {
  const _$_Content(this.user, [this.authError]);

  @override
  final User user;
  @override
  final AuthError? authError;

  @override
  String toString() {
    return 'AuthState1.content(user: $user, authError: $authError)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Content &&
            const DeepCollectionEquality().equals(other.user, user) &&
            const DeepCollectionEquality().equals(other.authError, authError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(user),
      const DeepCollectionEquality().hash(authError));

  @JsonKey(ignore: true)
  @override
  _$$_ContentCopyWith<_$_Content> get copyWith =>
      __$$_ContentCopyWithImpl<_$_Content>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(User user, AuthError? authError) loading,
    required TResult Function(User user, AuthError? authError) content,
    required TResult Function(User user, AuthError authError) error,
    required TResult Function(User user, AuthError? authError) initial,
    required TResult Function(User user, AuthError? authError) userUpdated,
  }) {
    return content(user, authError);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(User user, AuthError? authError)? loading,
    TResult Function(User user, AuthError? authError)? content,
    TResult Function(User user, AuthError authError)? error,
    TResult Function(User user, AuthError? authError)? initial,
    TResult Function(User user, AuthError? authError)? userUpdated,
  }) {
    return content?.call(user, authError);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(User user, AuthError? authError)? loading,
    TResult Function(User user, AuthError? authError)? content,
    TResult Function(User user, AuthError authError)? error,
    TResult Function(User user, AuthError? authError)? initial,
    TResult Function(User user, AuthError? authError)? userUpdated,
    required TResult orElse(),
  }) {
    if (content != null) {
      return content(user, authError);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Loading value) loading,
    required TResult Function(_Content value) content,
    required TResult Function(_Error value) error,
    required TResult Function(_Initial value) initial,
    required TResult Function(_UserUpdated value) userUpdated,
  }) {
    return content(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Loading value)? loading,
    TResult Function(_Content value)? content,
    TResult Function(_Error value)? error,
    TResult Function(_Initial value)? initial,
    TResult Function(_UserUpdated value)? userUpdated,
  }) {
    return content?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Loading value)? loading,
    TResult Function(_Content value)? content,
    TResult Function(_Error value)? error,
    TResult Function(_Initial value)? initial,
    TResult Function(_UserUpdated value)? userUpdated,
    required TResult orElse(),
  }) {
    if (content != null) {
      return content(this);
    }
    return orElse();
  }
}

abstract class _Content implements AuthState1 {
  const factory _Content(final User user, [final AuthError? authError]) =
      _$_Content;

  @override
  User get user;
  AuthError? get authError;
  @override
  @JsonKey(ignore: true)
  _$$_ContentCopyWith<_$_Content> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_ErrorCopyWith<$Res> implements $AuthState1CopyWith<$Res> {
  factory _$$_ErrorCopyWith(_$_Error value, $Res Function(_$_Error) then) =
      __$$_ErrorCopyWithImpl<$Res>;
  @override
  $Res call({User user, AuthError authError});
}

/// @nodoc
class __$$_ErrorCopyWithImpl<$Res> extends _$AuthState1CopyWithImpl<$Res>
    implements _$$_ErrorCopyWith<$Res> {
  __$$_ErrorCopyWithImpl(_$_Error _value, $Res Function(_$_Error) _then)
      : super(_value, (v) => _then(v as _$_Error));

  @override
  _$_Error get _value => super._value as _$_Error;

  @override
  $Res call({
    Object? user = freezed,
    Object? authError = freezed,
  }) {
    return _then(_$_Error(
      user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      authError == freezed
          ? _value.authError
          : authError // ignore: cast_nullable_to_non_nullable
              as AuthError,
    ));
  }
}

/// @nodoc

class _$_Error implements _Error {
  const _$_Error(this.user, this.authError);

  @override
  final User user;
  @override
  final AuthError authError;

  @override
  String toString() {
    return 'AuthState1.error(user: $user, authError: $authError)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Error &&
            const DeepCollectionEquality().equals(other.user, user) &&
            const DeepCollectionEquality().equals(other.authError, authError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(user),
      const DeepCollectionEquality().hash(authError));

  @JsonKey(ignore: true)
  @override
  _$$_ErrorCopyWith<_$_Error> get copyWith =>
      __$$_ErrorCopyWithImpl<_$_Error>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(User user, AuthError? authError) loading,
    required TResult Function(User user, AuthError? authError) content,
    required TResult Function(User user, AuthError authError) error,
    required TResult Function(User user, AuthError? authError) initial,
    required TResult Function(User user, AuthError? authError) userUpdated,
  }) {
    return error(user, authError);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(User user, AuthError? authError)? loading,
    TResult Function(User user, AuthError? authError)? content,
    TResult Function(User user, AuthError authError)? error,
    TResult Function(User user, AuthError? authError)? initial,
    TResult Function(User user, AuthError? authError)? userUpdated,
  }) {
    return error?.call(user, authError);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(User user, AuthError? authError)? loading,
    TResult Function(User user, AuthError? authError)? content,
    TResult Function(User user, AuthError authError)? error,
    TResult Function(User user, AuthError? authError)? initial,
    TResult Function(User user, AuthError? authError)? userUpdated,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(user, authError);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Loading value) loading,
    required TResult Function(_Content value) content,
    required TResult Function(_Error value) error,
    required TResult Function(_Initial value) initial,
    required TResult Function(_UserUpdated value) userUpdated,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Loading value)? loading,
    TResult Function(_Content value)? content,
    TResult Function(_Error value)? error,
    TResult Function(_Initial value)? initial,
    TResult Function(_UserUpdated value)? userUpdated,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Loading value)? loading,
    TResult Function(_Content value)? content,
    TResult Function(_Error value)? error,
    TResult Function(_Initial value)? initial,
    TResult Function(_UserUpdated value)? userUpdated,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements AuthState1 {
  const factory _Error(final User user, final AuthError authError) = _$_Error;

  @override
  User get user;
  AuthError get authError;
  @override
  @JsonKey(ignore: true)
  _$$_ErrorCopyWith<_$_Error> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_InitialCopyWith<$Res> implements $AuthState1CopyWith<$Res> {
  factory _$$_InitialCopyWith(
          _$_Initial value, $Res Function(_$_Initial) then) =
      __$$_InitialCopyWithImpl<$Res>;
  @override
  $Res call({User user, AuthError? authError});
}

/// @nodoc
class __$$_InitialCopyWithImpl<$Res> extends _$AuthState1CopyWithImpl<$Res>
    implements _$$_InitialCopyWith<$Res> {
  __$$_InitialCopyWithImpl(_$_Initial _value, $Res Function(_$_Initial) _then)
      : super(_value, (v) => _then(v as _$_Initial));

  @override
  _$_Initial get _value => super._value as _$_Initial;

  @override
  $Res call({
    Object? user = freezed,
    Object? authError = freezed,
  }) {
    return _then(_$_Initial(
      user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      authError == freezed
          ? _value.authError
          : authError // ignore: cast_nullable_to_non_nullable
              as AuthError?,
    ));
  }
}

/// @nodoc

class _$_Initial implements _Initial {
  const _$_Initial(this.user, [this.authError]);

  @override
  final User user;
  @override
  final AuthError? authError;

  @override
  String toString() {
    return 'AuthState1.initial(user: $user, authError: $authError)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Initial &&
            const DeepCollectionEquality().equals(other.user, user) &&
            const DeepCollectionEquality().equals(other.authError, authError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(user),
      const DeepCollectionEquality().hash(authError));

  @JsonKey(ignore: true)
  @override
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      __$$_InitialCopyWithImpl<_$_Initial>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(User user, AuthError? authError) loading,
    required TResult Function(User user, AuthError? authError) content,
    required TResult Function(User user, AuthError authError) error,
    required TResult Function(User user, AuthError? authError) initial,
    required TResult Function(User user, AuthError? authError) userUpdated,
  }) {
    return initial(user, authError);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(User user, AuthError? authError)? loading,
    TResult Function(User user, AuthError? authError)? content,
    TResult Function(User user, AuthError authError)? error,
    TResult Function(User user, AuthError? authError)? initial,
    TResult Function(User user, AuthError? authError)? userUpdated,
  }) {
    return initial?.call(user, authError);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(User user, AuthError? authError)? loading,
    TResult Function(User user, AuthError? authError)? content,
    TResult Function(User user, AuthError authError)? error,
    TResult Function(User user, AuthError? authError)? initial,
    TResult Function(User user, AuthError? authError)? userUpdated,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(user, authError);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Loading value) loading,
    required TResult Function(_Content value) content,
    required TResult Function(_Error value) error,
    required TResult Function(_Initial value) initial,
    required TResult Function(_UserUpdated value) userUpdated,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Loading value)? loading,
    TResult Function(_Content value)? content,
    TResult Function(_Error value)? error,
    TResult Function(_Initial value)? initial,
    TResult Function(_UserUpdated value)? userUpdated,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Loading value)? loading,
    TResult Function(_Content value)? content,
    TResult Function(_Error value)? error,
    TResult Function(_Initial value)? initial,
    TResult Function(_UserUpdated value)? userUpdated,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements AuthState1 {
  const factory _Initial(final User user, [final AuthError? authError]) =
      _$_Initial;

  @override
  User get user;
  AuthError? get authError;
  @override
  @JsonKey(ignore: true)
  _$$_InitialCopyWith<_$_Initial> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_UserUpdatedCopyWith<$Res>
    implements $AuthState1CopyWith<$Res> {
  factory _$$_UserUpdatedCopyWith(
          _$_UserUpdated value, $Res Function(_$_UserUpdated) then) =
      __$$_UserUpdatedCopyWithImpl<$Res>;
  @override
  $Res call({User user, AuthError? authError});
}

/// @nodoc
class __$$_UserUpdatedCopyWithImpl<$Res> extends _$AuthState1CopyWithImpl<$Res>
    implements _$$_UserUpdatedCopyWith<$Res> {
  __$$_UserUpdatedCopyWithImpl(
      _$_UserUpdated _value, $Res Function(_$_UserUpdated) _then)
      : super(_value, (v) => _then(v as _$_UserUpdated));

  @override
  _$_UserUpdated get _value => super._value as _$_UserUpdated;

  @override
  $Res call({
    Object? user = freezed,
    Object? authError = freezed,
  }) {
    return _then(_$_UserUpdated(
      user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      authError == freezed
          ? _value.authError
          : authError // ignore: cast_nullable_to_non_nullable
              as AuthError?,
    ));
  }
}

/// @nodoc

class _$_UserUpdated implements _UserUpdated {
  const _$_UserUpdated(this.user, [this.authError]);

  @override
  final User user;
  @override
  final AuthError? authError;

  @override
  String toString() {
    return 'AuthState1.userUpdated(user: $user, authError: $authError)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserUpdated &&
            const DeepCollectionEquality().equals(other.user, user) &&
            const DeepCollectionEquality().equals(other.authError, authError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(user),
      const DeepCollectionEquality().hash(authError));

  @JsonKey(ignore: true)
  @override
  _$$_UserUpdatedCopyWith<_$_UserUpdated> get copyWith =>
      __$$_UserUpdatedCopyWithImpl<_$_UserUpdated>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(User user, AuthError? authError) loading,
    required TResult Function(User user, AuthError? authError) content,
    required TResult Function(User user, AuthError authError) error,
    required TResult Function(User user, AuthError? authError) initial,
    required TResult Function(User user, AuthError? authError) userUpdated,
  }) {
    return userUpdated(user, authError);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(User user, AuthError? authError)? loading,
    TResult Function(User user, AuthError? authError)? content,
    TResult Function(User user, AuthError authError)? error,
    TResult Function(User user, AuthError? authError)? initial,
    TResult Function(User user, AuthError? authError)? userUpdated,
  }) {
    return userUpdated?.call(user, authError);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(User user, AuthError? authError)? loading,
    TResult Function(User user, AuthError? authError)? content,
    TResult Function(User user, AuthError authError)? error,
    TResult Function(User user, AuthError? authError)? initial,
    TResult Function(User user, AuthError? authError)? userUpdated,
    required TResult orElse(),
  }) {
    if (userUpdated != null) {
      return userUpdated(user, authError);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Loading value) loading,
    required TResult Function(_Content value) content,
    required TResult Function(_Error value) error,
    required TResult Function(_Initial value) initial,
    required TResult Function(_UserUpdated value) userUpdated,
  }) {
    return userUpdated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Loading value)? loading,
    TResult Function(_Content value)? content,
    TResult Function(_Error value)? error,
    TResult Function(_Initial value)? initial,
    TResult Function(_UserUpdated value)? userUpdated,
  }) {
    return userUpdated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Loading value)? loading,
    TResult Function(_Content value)? content,
    TResult Function(_Error value)? error,
    TResult Function(_Initial value)? initial,
    TResult Function(_UserUpdated value)? userUpdated,
    required TResult orElse(),
  }) {
    if (userUpdated != null) {
      return userUpdated(this);
    }
    return orElse();
  }
}

abstract class _UserUpdated implements AuthState1 {
  const factory _UserUpdated(final User user, [final AuthError? authError]) =
      _$_UserUpdated;

  @override
  User get user;
  AuthError? get authError;
  @override
  @JsonKey(ignore: true)
  _$$_UserUpdatedCopyWith<_$_UserUpdated> get copyWith =>
      throw _privateConstructorUsedError;
}
