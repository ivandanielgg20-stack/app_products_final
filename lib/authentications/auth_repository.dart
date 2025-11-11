
import 'package:app_final/authentications/users/user.dart';

abstract class AuthRepository {
  Future<User> checkSession(String token);
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String fullname);
}

