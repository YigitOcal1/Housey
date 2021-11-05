class UserModel {
  String? uid;
  String? email;
  String? password;
  String? username;

  UserModel({this.uid, this.email, this.password, this.username});

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      password: map['password'],
      username: map['username'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'password': password,
      'username': username,
    };
  }
}
