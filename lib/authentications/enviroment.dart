import 'package:flutter_dotenv/flutter_dotenv.dart';

class Enviroment {
  static Future<void> initEnviroment() async {
    await dotenv.load(fileName: ".env");
  }
  static String get apiUrl {
    return dotenv.env['API_URL'] ?? 'NOT_FOUND';
  }
}
