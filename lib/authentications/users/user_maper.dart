import 'package:app_final/authentications/users/user.dart';

class UserMapper {
  static User jsonToEntity(Map<String, dynamic> json) {
    // ✅ Depuración: imprime el JSON recibido
    print('📦 Mapeando usuario desde JSON: $json');

    return User(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      fullname: json['fullName'] ?? json['fullname'] ?? '',
      roles: (json['roles'] is List)
          ? List<String>.from(json['roles'].map((role) => role.toString()))
          : [],
      // ✅ Token seguro: siempre lo convierte a String
      token: (json['token'] ?? json['accessToken'] ?? '').toString(),
    );
  }
}