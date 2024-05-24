import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:startupspace/domain/entities/user.dart';
abstract class AuthRepository {
  Future<UserApp> login(String email, String password, Function customshowSnackBar);
  Future<UserApp> register(String email, String password, String fullName,BuildContext context);
  Future<UserCredential> googleLogin();
  Future<void> logout();
}
