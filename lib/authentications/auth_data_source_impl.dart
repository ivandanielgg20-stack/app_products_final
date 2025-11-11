import 'package:dio/dio.dart';
import 'package:app_final/authentications/auth_datasource.dart';
import 'package:app_final/authentications/users/user.dart';
import 'package:app_final/authentications/users/user_maper.dart';
import 'package:app_final/authentications/enviroment.dart';
class AuthDataSourceImpl extends AuthDataSource {
  final dio = Dio(BaseOptions(baseUrl: Enviroment.apiUrl));

  @override
  Future<User> checkSession(String token) async {
    final response = await dio.get('/auth/check', options: Options(headers: {'Authorization': 'Bearer $token'}));
    return UserMapper.jsonToEntity(response.data);
  }

  @override
  Future<User> login(String email, String password) async {
    final response = await dio.post('/auth/login', data: {'email': email, 'password': password});
    return UserMapper.jsonToEntity(response.data);
  }

  @override
  Future<User> register(String email, String password, String fullname) async {
    final response = await dio.post('/auth/register', data: {'email': email, 'password': password, 'fullname': fullname});
    return UserMapper.jsonToEntity(response.data);
  }
}

