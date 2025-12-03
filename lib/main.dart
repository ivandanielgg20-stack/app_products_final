import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_final/themes&colors/AppTheme.dart';
import 'package:app_final/router_paths/approuter.dart';
import 'package:app_final/authentications/enviroment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Enviroment.initEnviroment();

  // ✅ Prueba directa de FlutterSecureStorage
  final testStorage = FlutterSecureStorage();
  await testStorage.write(key: 'testKey', value: '123');
  final result = await testStorage.read(key: 'testKey');
  print('Test de storage: $result'); // ✅ debe imprimir 123

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      theme: AppTheme().getTheme(),
      debugShowCheckedModeBanner: false,
    );
  }
}