import 'dart:convert';

enum SignUpOption { emailPassword, google, twitter, facebook }

class User {
  final String email;
  String? phone, name, profilePic, uid;
  final SignUpOption signUpOption;

  User(
      {required this.email,
      this.uid,
      this.name,
      this.phone,
      this.profilePic,
      this.signUpOption = SignUpOption.emailPassword});

  User.empty() : this(email: "");

  User copyWith(
      {String? name,
      String? email,
      String? phone,
      String? profilePic,
      signUpOption}) {
    return User(
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        profilePic: profilePic ?? this.profilePic,
        signUpOption: signUpOption ?? this.signUpOption);
  }

  // changeImageUrl({required String imageUrl}) {
  //   profilePic = imageUrl;
  // }

  User.signedUpWithGoogle()
      : email = "",
        phone = "",
        signUpOption = SignUpOption.google,
        name = "",
        profilePic = "";

  String toJson() {
    final userMap = {
      "name": name,
      "email": email,
      "phone": phone,
      "imageURL": profilePic,
      "signUpOption": signUpOption.name
    };
    return jsonEncode(userMap);
  }

  factory User.fromJson(String userJson) {
    final decoded = jsonDecode(userJson) as Map<String, dynamic>;
    return User(
      email: decoded["email"] ?? "email address",
      phone: decoded["phone"],
      profilePic: decoded["imageURL"],
      name: decoded["name"],
      signUpOption: convertToSignUpOption(decoded["signUpOption"]),
    );
  }
}

SignUpOption convertToSignUpOption(String option) {
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
