import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:startupspace/presentation/providers/auth/register_form_provider.dart';
import 'package:startupspace/widgets/shared/custom_text_form_field.dart';

final imageUrlProvider = StateProvider<String>((ref) {
  return "";
});
final isLoadingProvider = StateProvider<bool>((ref) {
  return false;
});
final nameProvider = StateProvider<String>((ref) {
  return "";
});

final emailProvider = StateProvider<String>((ref) {
  return "" ;
});
final passwordProvider = StateProvider<String>((ref) {
  return "" ;
});
class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerForm = ref.watch(registerformProvider);
    final image = ref.watch(imageUrlProvider);
    final loading = ref.watch(isLoadingProvider);
    final name = ref.watch(nameProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    // tomar la foto de galeria
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);

                    if (image != null) {
                      try {
                        ref
                            .read(isLoadingProvider.notifier)
                            .update((state) => true);
                        // Sube la imagen a Firebase Storage
                        final storageRef = FirebaseStorage.instance.ref().child(
                            'imageuserPhoto/${DateTime.now().millisecondsSinceEpoch}');
                        final uploadTask = storageRef.putFile(File(image.path));
                        await uploadTask.whenComplete(() => null);

                        // Obtiene la URL de la imagen subida
                        final imageUrl = await storageRef.getDownloadURL();

                        // Imprime la URL de la imagen subida
                        print('URL de la imagen subida: $imageUrl');

                        // Devuelve la URL de la imagen subida
                        ref
                            .read(imageUrlProvider.notifier)
                            .update((state) => imageUrl);
                        ref
                            .read(isLoadingProvider.notifier)
                            .update((state) => false);
                      } catch (error) {
                        return null;
                      }
                    }

                    // Si no se seleccionó ninguna imagen, devuelve null
                    return null;
                    //subir foto(file) a firebase
                    //s
                  },
                  child: loading
                      ? const CircularProgressIndicator()
                      : image.isEmpty
                          ? const UserIconWithAddButton(
                              addButtonColor: Color(0xff00cdac),
                              circleColor: Color(0xffd9d9d9))
                          : CircleAvatar(
                              radius: 25,
                              child: Image.network(
                                image,
                              ),
                            )),
             const Text(
                "Register",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
            const  SizedBox(
                height: 10,
              ),
            const  Text(
                "Create an Account",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w200),
              ),
           const   SizedBox(
                height: 10,
              ),
            const  Text(
                "startup space waits",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w200),
              ),
            const  SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                const Text(
                    "Nombre",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                const  SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                      width: 320,
                      height: 60,
                      child: CustomTextInput(
                          obscureText: false,
                          hint: "Enter Username",
                          onChanged: (value) => ref
                              .read(nameProvider.notifier)
                              .update((state) => value)
                          // ref
                          //     .read(registerformProvider.notifier)
                          //     .onEmailChange(value),
                          // errorMessage: registerForm.isFormPosted
                          //     ? registerForm.email.errorMessage
                          //     : null,
                          ))
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 const Text(
                    "Email",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                 const SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                      width: 320,
                      height: 60,
                      child: CustomTextInput(
                        obscureText: false,
                        hint: "EnterEmail",
                        onChanged: (value) => ref
                            .read(registerformProvider.notifier)
                            .onEmailChange(value),
                        errorMessage: registerForm.isFormPosted
                            ? registerForm.name.errorMessage
                            : null,
                      ))
                ],
              ),
            const  SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 const Text(
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
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  // Navegar a la pantalla de inicio de sesión
                },
                child: RichText(
                  text: TextSpan(
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
                        horizontal: 80, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () async{
                    if (registerForm.email.isValid &&
                        registerForm.password.isValid||loading==false||image!="") {
                            try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: registerForm.email.value,
      password: registerForm.password.value,
    );
    
    // Obtén el UID del usuario recién creado
    String uid = credential.user!.uid;
    
    // Crea el documento en Firestore con el UID como ID del documento
    await FirebaseFirestore.instance.collection("users").doc(uid).set({
       "name": name,
       "colaboration" :0,
       "inatablespace":false,
       "showUsers":false,
       "proyect":0,
       "photo":image,
       "email":registerForm.email.value

    });
    
  
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Contraseña muy débil")));
    } else if (e.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("La Cuenta ya existe")));
    }
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Error del servidor: $e")));
  }
  // throw Exception('Error inesperado');
                      // FirebaseFirestore.instance
                      //     .collection("users")
                      //     .add({"name": name, "photo": image})
                      //     .then((value) => {
                      //           ref
                      //               .read(registerformProvider.notifier)
                      //               .onFormSubmit(context)
                      //         })
                      //     .then((value) => {
                      //       ref.read(imageUrlProvider.notifier).update((state) => "")
                      //     });

                      // context.push("/additionalInfo");
                    } else {
                      // ref
                      //     .read(registerformProvider.notifier)
                      //     .onFormSubmit(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Credenciales no Correctas o complete todo los campos'),
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

class UserIconWithAddButton extends StatelessWidget {
  final double size;
  final IconData userIcon;
  final IconData addIcon;
  final Color circleColor;
  final Color iconColor;
  final double addButtonSize;
  final Color addButtonColor;

  const UserIconWithAddButton({
    Key? key,
    this.size = 100.0,
    this.userIcon = Icons.person,
    this.addIcon = Icons.add,
    this.circleColor = Colors.grey,
    this.iconColor = Colors.white,
    this.addButtonSize = 30.0,
    this.addButtonColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main circle with user icon
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: circleColor,
          ),
          child: Center(
            child: Icon(
              userIcon,
              color: iconColor,
              size: size * 0.5,
            ),
          ),
        ),
        // Smaller circle with add icon
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: addButtonSize,
            height: addButtonSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: addButtonColor,
              border: Border.all(
                color: Colors.white,
                width: 2.0,
              ),
            ),
            child: Center(
              child: Icon(
                addIcon,
                color: Colors.white,
                size: addButtonSize * 0.6,
              ),
            ),
          ),
        ),
      ],
    );
  }
}