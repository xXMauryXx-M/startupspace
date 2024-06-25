import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:startupspace/domain/datasource/auth_datasource.dart';
import 'package:startupspace/domain/entities/user.dart';

class AuthDatasourceImpl extends AuthDatasource {
  @override
  Future<UserApp> login(
      String email, String password, Function customshowSnackBar) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage =
              'Usuario no encontrado. Por favor, revisa tu correo electrónico.';
          break;
        case 'wrong-password':
          errorMessage =
              'Contraseña incorrecta. Por favor, intenta nuevamente.';
          break;
        case 'invalid-credential':
          errorMessage = 'La cuenta no existe❌';
          break;
        default:
          errorMessage =
              'Ha ocurrido un error. Por favor, intenta nuevamente más tarde.';
      }
      customshowSnackBar(errorMessage);
    } catch (e) {
      customshowSnackBar(
          'Ha ocurrido un error. Por favor, intenta nuevamente más tarde.');
    }
    return UserApp(
      uid: "",
      email: "email@gmail.com",
      fullName: "asd",
    );
  }

 @override
Future<UserApp> register(String email, String password, String fullName, BuildContext context) async {
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    // Obtén el UID del usuario recién creado
    String uid = credential.user!.uid;
    
    // Crea el documento en Firestore con el UID como ID del documento
    await FirebaseFirestore.instance.collection("users").doc(uid).set({
       "name": fullName,
       "colaboration" :0,
       "inatablespace":false,
       "showUsers":false,
       "proyect":false

    });
    
    return UserApp(
      uid: uid,
      email: credential.user!.email!,
      fullName: fullName,
    );
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
  throw Exception('Error inesperado');
}

  @override
  Future<UserCredential> googleLogin() async {
    GoogleSignInAccount? googleuser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleauth = await googleuser?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleauth?.accessToken,
      idToken: googleauth?.idToken,
    );
    // UserCredential userCretendial =
    //     await FirebaseAuth.instance.signInWithCredential(credential);

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
