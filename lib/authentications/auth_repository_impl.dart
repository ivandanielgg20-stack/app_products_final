import 'package:app_final/authentications/auth_data_source_impl.dart';
import 'package:app_final/authentications/auth_datasource.dart';
import 'package:app_final/authentications/auth_repository.dart';
import 'package:app_final/authentications/users/user.dart';



class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource dataSource;
  AuthRepositoryImpl({AuthDataSource? dataSource})
      : dataSource = dataSource ?? AuthDataSourceImpl();

  @override
  Future<User> checkSession(String token) => dataSource.checkSession(token);

  @override
  Future<User> login(String email, String password) => dataSource.login(email, password);

  @override
  Future<User> register(String email, String password, String fullname) =>
      dataSource.register(email, password, fullname);
}
