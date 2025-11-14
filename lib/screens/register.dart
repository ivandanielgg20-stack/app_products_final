import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app_final/authentications/auth_provider.dart';
import 'package:app_final/authentications/register_form_provider.dart';
import 'package:app_final/buttons/custombutton.dart';
import 'package:app_final/screens/geometricalBackground.dart';
import 'package:app_final/themes&colors/CustomTextFormField.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textStyles = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: GeometricalBackground(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (!context.canPop()) return;
                        context.pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios,
                          size: 40, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'crear cuenta',
                      style:
                          textStyles.titleLarge?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius:
                        const BorderRadius.only(topLeft: Radius.circular(100)),
                  ),
                  child: const _RegisterForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends ConsumerWidget {
  const _RegisterForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = Theme.of(context).textTheme;
    final form = ref.watch(registerFormProvider);
    final auth = ref.watch(authProvider);

    if (auth.status == AuthStatus.authenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/');
      });
    }

    final errorMessage = auth.errorMessage ?? '';
    final passwordsMismatch =
        form.password.isNotEmpty &&
        form.confirmPassword.isNotEmpty &&
        form.password != form.confirmPassword;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Text('New Account', style: textStyles.titleMedium),
          const SizedBox(height: 20),

          Customtextformfield(
            label: 'Nombre Completo',
            keyboardType: TextInputType.name,
            onChanged: (v) =>
                ref.read(registerFormProvider.notifier).onFullnameChanged(v!),
          ),
          const SizedBox(height: 30),

          Customtextformfield(
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            onChanged: (v) =>
                ref.read(registerFormProvider.notifier).onEmailChanged(v!),
          ),
          if (form.emailError.isNotEmpty)
            Text(form.emailError,
                style: textStyles.bodyMedium?.copyWith(color: Colors.red)),
          const SizedBox(height: 30),

          Customtextformfield(
            label: 'Password',
            obscureText: true,
            onChanged: (v) =>
                ref.read(registerFormProvider.notifier).onPasswordChanged(v!),
          ),
          if (form.passwordError.isNotEmpty)
            Text(form.passwordError,
                style: textStyles.bodyMedium?.copyWith(color: Colors.red)),
          const SizedBox(height: 30),

          Customtextformfield(
            label: 'Repita la contraseña',
            obscureText: true,
            onChanged: (v) => ref
                .read(registerFormProvider.notifier)
                .onConfirmPasswordChanged(v!),
          ),
          const SizedBox(height: 12),

          if (passwordsMismatch)
            Text(
              'Las contraseñas no coinciden',
              style: textStyles.bodyMedium?.copyWith(color: Colors.red),
            ),
          if (errorMessage.isNotEmpty)
            Text(
              errorMessage,
              style: textStyles.bodyMedium?.copyWith(color: Colors.red),
            ),

          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(text: form.isLoading ? 'Creando...' : 'Crear',
                buttonColor: Colors.black,
                  onPressed: (form.isLoading || passwordsMismatch)
                      ? null: () async {
                       try {
                    await ref.read(registerFormProvider.notifier).submit(ref, context);
                   } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                content: Text(e.toString()),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
),
          ),

          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Ya tienes una cuenta'),
              TextButton(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/login');
                  }
                },
                child: const Text(' ingresa aqui'),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
