import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenHelper {
  static const _storage = FlutterSecureStorage();
  static const _key = 'authToken';

  static Future<String?> getToken() async {
    final token = await _storage.read(key: _key);
    print(' Leyendo token del storage: $token');
    return (token != null && token.isNotEmpty) ? token : null;
  }

  static Future<void> saveToken(String token) async {
    print('Guardando token en storage: $token');
    await _storage.write(key: _key, value: token);
  }

  static Future<void> deleteToken() async {
    print(' Eliminando token del storage');
    await _storage.delete(key: _key);
  }
}