abstract class AuthenticationRepository {
  Future<bool> login(String username, String password);
  Future<void> logout();
  Future<bool> isLoggedIn();
}
