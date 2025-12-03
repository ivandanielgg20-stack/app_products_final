import 'package:app_final/authentications/users/token_helper.dart';
import 'package:app_final/manage_errors/CustomError.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_final/authentications/auth_provider.dart'; // ✅ helper para verificar token
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';


class LoginFormState {
  final String email;
  final String password;
  final bool isLoading;
  final String emailError;
  final String passwordError;

  LoginFormState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.emailError = '',
    this.passwordError = '',
  });

  LoginFormState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    String? emailError,
    String? passwordError,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
    );
  }
}

class LoginFormNotifier extends StateNotifier<LoginFormState> {
  LoginFormNotifier() : super(LoginFormState());

  void onEmailChanged(String value) {
    final isValid = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
    state = state.copyWith(
      email: value,
      emailError: isValid ? '' : 'Email inválido',
    );
  }

  void onPasswordChanged(String value) {
    final isValid = value.length >= 6 &&
        RegExp(r'[A-Z]').hasMatch(value) &&
        RegExp(r'[a-z]').hasMatch(value) &&
        RegExp(r'\d').hasMatch(value);
    state = state.copyWith(
      password: value,
      passwordError: isValid ? '' : 'Debe tener mayúscula, minúscula y número',
    );
  }

  Future<void> submit(WidgetRef ref, BuildContext context) async {
    if (state.emailError.isNotEmpty || state.passwordError.isNotEmpty) return;
    if (state.email.isEmpty || state.password.isEmpty) return;

    state = state.copyWith(isLoading: true);
    try {
      print('➡️ Intentando login con: ${state.email}');
      await ref.read(authProvider.notifier).login(state.email, state.password);

      final authState = ref.read(authProvider);
      print('📡 Estado después de login: ${authState.status}, error: ${authState.errorMessage}');

      final token = await TokenHelper.getToken();
      print('🔐 Token después del login: $token');

      if (authState.status == AuthStatus.authenticated && token != null && token.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Inicio de sesión exitoso!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/menu');
      } else {
        final errorMsg = authState.errorMessage?.isNotEmpty == true
            ? authState.errorMessage!
            : 'Error desconocido en login';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on CustomError catch (e) {
      print('❌ Error atrapado en login: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      print('❌ Error inesperado en login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error inesperado: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final loginFormProvider =
    StateNotifierProvider<LoginFormNotifier, LoginFormState>(
  (ref) => LoginFormNotifier(),
);