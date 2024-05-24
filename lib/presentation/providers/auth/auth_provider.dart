import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:startupspace/domain/entities/user.dart';
import 'package:startupspace/domain/repository/auth_respository.dart';
import 'package:startupspace/infrastrocture/repository/auth_repository_impl.dart';

final authProvider = StateNotifierProvider<AuthNotifier, UserApp>((ref) {
  final authRepositoy = AuthRepositoryImpl();
  return AuthNotifier(authRepository: authRepositoy);
});

class AuthNotifier extends StateNotifier<UserApp> {
  final AuthRepository authRepository;
  AuthNotifier({required this.authRepository})
      : super(UserApp(email: "", fullName: "", uid: ""));

  Future<void> loginUser(
      String email, String password, Function customshowSnackBar) async {
    try {
      await authRepository.login(email, password, customshowSnackBar);
    } catch (e) {
      print("ee$e");
    }
  }

  Future<void> registerUser(
      String email, String password, BuildContext context) async {
    try {
      await authRepository.register(email, password, "", context);
    } catch (e) {
      // logout();
    }
  }

  Future<void> logoutapp() async {
    try {
      authRepository.logout();
    } catch (e) {
      return;
    }
  }

  Future<void> googleLogin() async {
    try {
      authRepository.googleLogin();
    } catch (e) {
      return;
    }
  }
}

