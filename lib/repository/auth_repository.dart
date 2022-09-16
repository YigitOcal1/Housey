abstract class AuthRepository {
  void logIn(String email, String password);

  void register(String email, String password);

  Future addUserToDatabase(
    String username,
    String email,
    String password,
  );
}
