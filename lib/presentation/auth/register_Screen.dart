import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:startupspace/presentation/providers/auth/register_form_provider.dart';
import 'package:startupspace/widgets/shared/custom_text_form_field.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerForm = ref.watch(registerformProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                "Register",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Create an Account",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w200),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "startup space waits",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w200),
              ),
              SizedBox(
                height: 40,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Username or Email",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                      width: 320,
                      height: 60,
                      child: CustomTextInput(
                      obscureText: true,
                        hint: "Enter Username or Email",
                        onChanged: (value) => ref
                            .read(registerformProvider.notifier)
                            .onEmailChange(value),
                        errorMessage: registerForm.isFormPosted
                            ? registerForm.email.errorMessage
                            : null,
                      ))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                      width: 320,
                      height: 60,
                      child: CustomTextInput(
                        obscureText: true,

                        hint: "Enter Password",
                        onChanged: (value) => ref
                            .read(registerformProvider.notifier)
                            .onPasswordChange(value),
                        errorMessage: registerForm.isFormPosted
                            ? registerForm.password.errorMessage
                            : null,
                      ))
                ],
              ),
              SizedBox(
                height: 180,
              ),
              GestureDetector(
                onTap: () {
                  // Navegar a la pantalla de inicio de sesión
                },
                child: RichText(
                  text:  TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Dont have any account: ',
                        style: TextStyle(fontSize: 15),
                      ),
                      TextSpan(
                                  recognizer: TapGestureRecognizer()
          ..onTap = () {
            // Aquí puedes manejar el evento onTap, por ejemplo, navegar a la pantalla de registro
            context.go('/LoginScreen');
          },
                        text: 'Login',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w700), // Color verde
                      ),
                    ],
                  ),
                ),
              ),
              FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 120, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                
                    if (registerForm.email.isValid &&
                        registerForm.password.isValid) {
                      ref
                          .read(registerformProvider.notifier)
                          .onFormSubmit(context);
                      // context.push("/additionalInfo");
                    } else {
                        ref.read(registerformProvider.notifier).onFormSubmit(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Credenciales no Correctas'),
                          duration:
                              Duration(seconds: 3), // Duración del Snackbar
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
