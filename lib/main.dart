import 'package:app_final/themes&colors/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_final/router_paths/app_router.dart';
import 'package:app_final/authentications/enviroment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Enviroment.initEnviroment();
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
