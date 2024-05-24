import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:startupspace/infrastrocture/inputs/email.dart';
import 'package:startupspace/infrastrocture/inputs/inputs.dart';
import 'package:startupspace/presentation/providers/auth/auth_provider.dart';

class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.email = const Email.pure(),
      this.password = const Password.pure()});

  LoginFormState copywith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
  }) =>
      LoginFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isFormPosted,
        email: email ?? this.email,
        password: password ?? this.password,
      );
}

//como implementamos el notifier
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Function(String, String, Function) loginUserCallback;
  LoginFormNotifier({required this.loginUserCallback})
      : super(LoginFormState());

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copywith(
        email: newEmail, isValid: Formz.validate([newEmail, state.password]));
  }

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    state = state.copywith(
      password: newPassword,
      // isValid: Formz.validate([newPassword, state.email]
    );
  }

  onFormSubmit(Function customshowSnackBar) async {
    _touchEveryField();
    if (!state.isValid) return;
    await loginUserCallback(state.email.value, state.password.value, customshowSnackBar);
  }

  _touchEveryField() {
    //esto es para cuando el usuario envia el formulario sin antes rellenar nada
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copywith(
        isFormPosted: true,
        email: email,
        password: password,
        isValid: Formz.validate([email, password]));
  }
}

//consume afuera
//el autodispose es para cuandp el usuario entre a la app y depues cierre seccion no le aparesca el login con los datos reyenados en elos input
final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  final loginUserCallback = ref.watch(authProvider.notifier).loginUser;
  return LoginFormNotifier(loginUserCallback: loginUserCallback);
});
