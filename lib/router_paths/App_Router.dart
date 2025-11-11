
import 'package:app_final/screens/Login.dart';
import 'package:app_final/screens/products.dart';
import 'package:app_final/screens/register.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const ProductsScreen(),
    ),
  ],
);
 