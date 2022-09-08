import 'dart:convert';

enum SignUpOption { emailPassword, google, twitter, facebook }

class User {
  final String email;
  String? phone, name, photoURL, uid;
  final SignUpOption signUpOption;
  final bool? signedIn;

  User({
    required this.email,
    required this.uid,
    this.name,
    this.phone,
    this.photoURL,
    this.signUpOption = SignUpOption.emailPassword,
    this.signedIn,
  });

  User.empty() : this(email: "", uid: "");

  User copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? photoURL,
    bool? signedIn,
    signUpOption,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoURL: photoURL ?? this.photoURL,
      signUpOption: signUpOption ?? this.signUpOption,
      signedIn: signedIn ?? this.signedIn,
      uid: uid,
    );
  }

  User.signedUpWithGoogle()
      : email = "",
        phone = "",
        signUpOption = SignUpOption.google,
        name = "",
        photoURL = "",
        uid = "",
        signedIn = true;

  String toJsonFromFirestore(Map data) {
    final userMap = {
      "name": name,
      "email": email,
      "phone": phone,
      "photoURL": photoURL,
      "signUpOption": signUpOption.name,
      "uid": uid,
      "signedIn": signedIn,
    };
    return jsonEncode(userMap);
  }

  String toJson() {
    final userMap = {
      "name": name,
      "email": email,
      "phone": phone,
      "photoURL": photoURL,
      "signUpOption": signUpOption.name,
      "uid": uid,
      "signedIn": signedIn,
    };
    return jsonEncode(userMap);
  }

  factory User.fromJson(String userJson) {
    final decoded = jsonDecode(userJson) as Map<String, dynamic>;
    return User(
        email: decoded["email"] ?? "email address",
        phone: decoded["phone"],
        photoURL: decoded["photoURL"],
        name: decoded["name"],
        signUpOption: convertToSignUpOption(decoded["signUpOption"],
            uid: decoded["uid"] ?? "User.fromJson failed to grab uid"),
        uid: decoded["uid"] ?? "User.fromJson failed to grab uid",
        signedIn: decoded["signedIn"]);
  }

  User signOut() {
    User signedOutUser = copyWith(signedIn: false);
    return signedOutUser;
  }
}

SignUpOption convertToSignUpOption(String option, {required uid}) {
  if (option == SignUpOption.emailPassword.name) {
    return SignUpOption.emailPassword;
  } else if (option == SignUpOption.google.name) {
    return SignUpOption.google;
  } else if (option == SignUpOption.facebook.name) {
    return SignUpOption.facebook;
  } else {
    return SignUpOption.twitter;
  }
}
