// lib/authentications/providers/login_form_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_final/authentications/auth_provider.dart';
import 'package:flutter_riverpod/legacy.dart';



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
        RegExp(r'[A-Za-z]').hasMatch(value) &&
        RegExp(r'\d').hasMatch(value);
    state = state.copyWith(
      password: value,
      passwordError: isValid ? '' : 'Contraseña débil',
    );
  }

  Future<void> submit(WidgetRef ref) async {
    if (state.emailError.isNotEmpty || state.passwordError.isNotEmpty) return;
    if (state.email.isEmpty || state.password.isEmpty) return;

    state = state.copyWith(isLoading: true);
    try {
      await ref.read(authProvider.notifier).login(state.email, state.password);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final loginFormProvider =
    StateNotifierProvider<LoginFormNotifier, LoginFormState>((ref) {
  return LoginFormNotifier();
});
