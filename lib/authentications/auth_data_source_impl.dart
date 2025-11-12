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
@override
Future<User> login(String email, String password) async {
  final response = await dio.post(
    '/auth/login',
    data: {
      'email': email,
      'password': password,
    },
    options: Options(
      headers: {'Content-Type': 'application/json'},
      validateStatus: (status) => status! < 500,
    ),
  );

  if (response.statusCode == 200) {
    return UserMapper.jsonToEntity(response.data);
  }

  throw Exception('Sesion iniciada: ${response.data['message'] ?? response.data}');
}



@override
Future<User> register(String email, String password, String fullname) async {
  final response = await dio.post(
    '/auth/register',
    data: {
      'email': email,
      'password': password,
      'fullName': fullname,
    },
    options: Options(
      headers: {'Content-Type': 'application/json'},
      validateStatus: (status) => status! < 500,
    ),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    return UserMapper.jsonToEntity(response.data);
  }

  throw Exception('Registro exitoso: ${response.data['message'] ?? response.data}');
}

}