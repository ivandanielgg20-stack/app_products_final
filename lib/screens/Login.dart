import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app_final/authentications/auth_provider.dart';
import 'package:app_final/authentications/login_form_provider.dart';
import 'package:app_final/buttons/custombutton.dart';
import 'package:app_final/screens/geometricalBackground.dart';
import 'package:app_final/themes&colors/CustomTextFormField.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

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
                const Icon(Icons.production_quantity_limits_rounded,
                    color: Colors.blueGrey, size: 100),
                const SizedBox(height: 80),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius:
                        const BorderRadius.only(topLeft: Radius.circular(100)),
                  ),
                  child: const _LoginForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends ConsumerWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = Theme.of(context).textTheme;
    final form = ref.watch(loginFormProvider);
    final auth = ref.watch(authProvider);

    if (auth.status == AuthStatus.authenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/');
      });
    }

    final errorMessage = auth.errorMessage ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Text('Login', style: textStyles.titleLarge),
          const SizedBox(height: 90),

          Customtextformfield(
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            onChanged: (v) =>
                ref.read(loginFormProvider.notifier).onEmailChanged(v!),
          ),
          if (form.emailError.isNotEmpty)
            Text(form.emailError,
                style: textStyles.bodyMedium?.copyWith(color: Colors.red)),
          const SizedBox(height: 30),

          Customtextformfield(
            label: 'Password',
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            onChanged: (v) =>
                ref.read(loginFormProvider.notifier).onPasswordChanged(v!),
          ),
          if (form.passwordError.isNotEmpty)
            Text(form.passwordError,
                style: textStyles.bodyMedium?.copyWith(color: Colors.red)),
          const SizedBox(height: 30),

          if (errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                errorMessage,
                style: textStyles.bodyMedium?.copyWith(color: Colors.red),
              ),
            ),

          SizedBox(
            width: double.infinity,
            child: CustomFilledButton(
              text: form.isLoading ? 'Cargando...' : 'Ingresar',
              buttonColor: Colors.black,
              onPressed: form.isLoading
                  ? null
                  : () => ref.read(loginFormProvider.notifier).submit(ref),
            ),
          ),

          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿no tienes cuenta?'),
              TextButton(
                onPressed: () => context.push('/register'),
                child: const Text('crea una aqui'),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
