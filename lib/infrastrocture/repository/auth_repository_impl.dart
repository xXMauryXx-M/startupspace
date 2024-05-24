import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:startupspace/domain/datasource/auth_datasource.dart';
import 'package:startupspace/domain/entities/user.dart';
import 'package:startupspace/domain/repository/auth_respository.dart';
import 'package:startupspace/infrastrocture/datasource/auth_datasource_impl.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl({AuthDatasource? datasource})
      : datasource = datasource ?? AuthDatasourceImpl();

  @override
  Future<UserApp> login(String email, String password,Function customshowSnackBar) {
    return datasource.login(email, password, customshowSnackBar);
  }

  @override
  Future<UserApp> register(
      String email, String password, String fullName, BuildContext context) {
    return datasource.register(email, password, fullName, context);
  }

  @override
  Future<UserCredential> googleLogin() {
    return datasource.googleLogin();
  }

  @override
  Future<void> logout() {
    return datasource.logout();
  }
}
