
import 'package:app_final/authentications/users/user.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'auth_repository_impl.dart';


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
      final user = await authRepository.login(email, password);
      state = state.copyWith(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.unauthenticated, errorMessage: e.toString());
    }
  }

  Future<void> register(String email, String password, String fullname) async {
    state = state.copyWith(status: AuthStatus.checking);
    try {
      final user = await authRepository.register(email, password, fullname);
      state = state.copyWith(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.unauthenticated, errorMessage: e.toString());
    }
  }

  void logout() {
    state = AuthProvider(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthProvider>((ref) {
  return AuthNotifier();
});
