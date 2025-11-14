
import 'package:app_final/manage_errors/CustomError.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_final/authentications/auth_provider.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
class RegisterFormState {
  final String fullname;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isLoading;
  final String emailError;
  final String passwordError;

  RegisterFormState({
    this.fullname = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isLoading = false,
    this.emailError = '',
    this.passwordError = '',
  });

  RegisterFormState copyWith({
    String? fullname,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isLoading,
    String? emailError,
    String? passwordError,
  }) {
    return RegisterFormState(
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
    );
  }
}

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  RegisterFormNotifier() : super(RegisterFormState());

  void onFullnameChanged(String value) =>
      state = state.copyWith(fullname: value);

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

  void onConfirmPasswordChanged(String value) =>
      state = state.copyWith(confirmPassword: value);

  Future<void> submit(WidgetRef ref, BuildContext context) async {
  if (state.password != state.confirmPassword) return;
  if (state.emailError.isNotEmpty || state.passwordError.isNotEmpty) return;
  if (state.fullname.isEmpty || state.email.isEmpty || state.password.isEmpty) return;

  state = state.copyWith(isLoading: true);
  try {
    await ref.read(authProvider.notifier).register(
      state.email,
      state.password,
      state.fullname,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Cuenta creada con éxito!'),
        backgroundColor: Colors.green,
      ),
    );
      context.go('/menu');
  } on CustomError catch (e) {
    throw Exception(e.message);
  } finally {
    state = state.copyWith(isLoading: false);
  }
}

}
final registerFormProvider =
    StateNotifierProvider<RegisterFormNotifier, RegisterFormState>(
  (ref) => RegisterFormNotifier(),
);