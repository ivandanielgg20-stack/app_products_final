import 'package:dio/dio.dart';
import 'package:app_final/authentications/auth_datasource.dart';
import 'package:app_final/authentications/users/user.dart';
import 'package:app_final/authentications/users/user_maper.dart';
import 'package:app_final/authentications/enviroment.dart';
import 'package:app_final/manage_errors/CustomError.dart';
class AuthDataSourceImpl extends AuthDataSource {
  final dio = Dio(BaseOptions(baseUrl: Enviroment.apiUrl));

  @override
  Future<User> checkSession(String token) async {
    final response = await dio.get(
      '/auth/check',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return UserMapper.jsonToEntity(response.data);
  }

  Future<User> login(String email, String password) async {
  try {
    final response = await dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
      options: Options(
        headers: {'Content-Type': 'application/json'},
        validateStatus: (status) => status! < 500,
      ),
    );

    if (response.statusCode == 200) {
      return UserMapper.jsonToEntity(response.data);
    } else {
      throw CustomError(
        message: response.data['message'] ?? 'Error desconocido',
        statusCode: response.statusCode,
      );
    }
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw CustomError(message: 'Tiempo de espera agotado', statusCode: 408);
    }
    if (e.response?.statusCode == 401) {
      throw CustomError(message: 'Credenciales incorrectas', statusCode: 401);
    }
    throw CustomError(
      message: e.message ?? 'Error de red',
      statusCode: e.response?.statusCode,
    );
  }
}

  @override

  Future<User> register(String email, String password, String fullname) async {
  try {
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
    } else {
      throw CustomError(
        message: response.data['message'] ?? 'Error desconocido',
        statusCode: response.statusCode,
      );
    }
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw CustomError(message: 'Tiempo de espera agotado', statusCode: 408);
    }
    if (e.response?.statusCode == 400) {
      throw CustomError(message: 'Datos inválidos', statusCode: 400);
    }
    throw CustomError(
      message: e.message ?? 'Error de red',
      statusCode: e.response?.statusCode,
    );
  }
}

}
