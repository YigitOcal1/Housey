import 'package:flutter/cupertino.dart';

import '../repository/auth_repository_impl.dart';

class RegisterViewModel extends ChangeNotifier {
  final _authRepository = AuthRepositoryImpl();
  Future<void> logIn(String email, String password) async {
    _authRepository.register(email, password);
  }

  Future<void> addUserToDatabase(
      String username, String email, String password) async {
    _authRepository.addUserToDatabase(username, email, password);
  }
}
