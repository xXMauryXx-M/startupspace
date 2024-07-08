import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:startupspace/widgets/shared/custom_text_form_field.dart';

final gmailProvider = StateProvider<String>((ref) {
  return "";
});
final passwordProvider = StateProvider<String>((ref) {
  return "";
});

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(gmailProvider);
    final password = ref.watch(passwordProvider);
    void _showError(String message) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    }

    final _auth = FirebaseAuth.instance;

    void _login() async {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        // Navega a la siguiente pantalla o muestra un mensaje de éxito
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          try {
            UserCredential userCredential =
                await _auth.createUserWithEmailAndPassword(
              email: email,
              password: password,
            );

            // Navega a la siguiente pantalla o muestra un mensaje de éxito
          } on FirebaseAuthException catch (e) {
            _showError(e.message ?? 'Error desconocido');
          }
        } else if (e.code == 'wrong-password') {
          _showError('Contraseña incorrecta.');
        } else {
          _showError(e.message ?? 'Error desconocido');
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              const Text(
                "Login",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 40,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Username or Email",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                      width: 320,
                      height: 60,
                      child: CustomTextInput(
                        onChanged: (p0) {
                          ref
                              .read(gmailProvider.notifier)
                              .update((state) => p0);
                        },
                        obscureText: false,
                        label: "Beatriz",
                        hint: "Enter Username or Email",
                      ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                      width: 320,
                      height: 60,
                      child: CustomTextInput(
                        obscureText: true,
                        onChanged: (p0) {
                          ref
                              .read(passwordProvider.notifier)
                              .update((state) => p0);
                        },
                      
                        label: "Beatriz",
                        hint: "Enter Password",
                      ))
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey, // Color de la línea
                        thickness: 1, // Grosor de la línea
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "O", // Tu elemento en el centro
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey, // Color de la línea
                        thickness: 1, // Grosor de la línea
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 130,
              ),
              GestureDetector(
                onTap: () {
                  // Navegar a la pantalla de inicio de sesión
                },
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      const TextSpan(
                        text: 'Dont have any account: ',
                        style: TextStyle(fontSize: 15),
                      ),
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.go('/RegisterScreen');
                          },
                        text: 'Register',
                        style: const TextStyle(
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
                        horizontal: 120, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    if (email.isEmpty || password.isEmpty) {
                      const snackbar =  SnackBar(
                          content:  Text("Porfavor completa todos los campos"));

                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    } else {
                      _login();
                    }
                  },
                  child: const Text(
                    "Login",
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
