import 'package:flutter/cupertino.dart';
import 'package:housey/repository/auth_repository_impl.dart';

class LoginViewModel extends ChangeNotifier {
  final _authRepository = AuthRepositoryImpl();
  Future<void> logIn(String email, String password) async {
    _authRepository.logIn(email, password);
  }
}
