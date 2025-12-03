import 'package:app_final/authentications/users/token_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_final/authentications/users/user.dart';
import 'package:app_final/authentications/auth_repository_impl.dart';
import 'package:flutter_riverpod/legacy.dart';

 // ✅ ruta corregida

enum AuthStatus { authenticated, unauthenticated, checking }

class AuthProvider {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  AuthProvider({
    this.status = AuthStatus.checking,
    this.user,
    this.errorMessage = '',
  });

  AuthProvider copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return AuthProvider(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthProvider> {
  final authRepository = AuthRepositoryImpl();

  AuthNotifier() : super(AuthProvider());

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.checking);
    try {
      print('📡 Llamando a login...');
      final user = await authRepository.login(email, password);

      if (user.token.isEmpty) throw Exception('Token vacío desde backend');

      await TokenHelper.saveToken(user.token);
      final check = await TokenHelper.getToken();
      print('🔐 Token verificado: $check');

      if (check == null || check.isEmpty) {
        throw Exception('El token no fue guardado correctamente');
      }

      state = state.copyWith(status: AuthStatus.authenticated, user: user);
      print('✅ Login exitoso');
    } catch (e) {
      print('❌ Error en login: $e');
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> register(String email, String password, String fullname) async {
    state = state.copyWith(status: AuthStatus.checking);
    try {
      print('📡 Llamando a register...');
      final user = await authRepository.register(email, password, fullname);

      if (user.token.isEmpty) throw Exception('Token vacío desde backend');

      await TokenHelper.saveToken(user.token);
      final check = await TokenHelper.getToken();
      print('🔐 Token verificado: $check');

      if (check == null || check.isEmpty) {
        throw Exception('El token no fue guardado correctamente');
      }

      state = state.copyWith(status: AuthStatus.authenticated, user: user);
      print('✅ Registro exitoso');
    } catch (e) {
      print('❌ Error en register: $e');
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
      );
    }
  }

  void logout() async {
    await TokenHelper.deleteToken();
    state = AuthProvider(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthProvider>((ref) {
  return AuthNotifier();
});

