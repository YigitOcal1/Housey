class UserModel {
 
  String? email;
  String? password;
  String? username;

  UserModel({ this.email, this.password, this.username});

  factory UserModel.fromMap(map) {
    return UserModel(
     
      email: map['email'],
      password: map['password'],
      username: map['username'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      
      'email': email,
      'password': password,
      'username': username,
    };
  }
}
