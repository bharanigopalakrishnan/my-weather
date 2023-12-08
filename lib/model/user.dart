class User {
  String? email;
  User({this.email});

  factory User.fromJson(json) {
    return User(
      email: json["email"],
    );
  }

  toJson() => {"email": email};

  User createInstance(json) {
    return User.fromJson(json);
  }
}
