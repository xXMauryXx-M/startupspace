//el state

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:startupspace/infrastrocture/inputs/email.dart';
import 'package:startupspace/infrastrocture/inputs/inputs.dart';
import 'package:startupspace/infrastrocture/inputs/name.dart';
import 'package:startupspace/presentation/providers/auth/auth_provider.dart';

class RegisterFormState {
  final Name name;
  final bool isPosting;
  final bool isValid;
  final Email email;
  final bool isFormPosted;
  final Password password;

  RegisterFormState({
    this.name=const Name.pure(),
    this.isPosting = false,
    this.isFormPosted = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.isValid = false,
  });

  copywith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
  }) =>
      RegisterFormState(
          isPosting: isPosting ?? this.isPosting,
          isFormPosted: isFormPosted ?? this.isFormPosted,
          isValid: isValid ?? this.isValid,
          email: email ?? this.email,
          password: password ?? this.password);
}

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Function(String, String, BuildContext context) registerUserCallback;
  RegisterFormNotifier({required this.registerUserCallback})
      : super(RegisterFormState());

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copywith(
        email: newEmail, isValid: Formz.validate([newEmail, state.password]));
  }

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    state = state.copywith(
        password: newPassword,
        isValid: Formz.validate([
          newPassword,
          state.email,
        ]));
  }

  onFormSubmit(BuildContext context) async {
    _touchEveryField();
    if (!state.isValid) return;

    await registerUserCallback(
        state.email.value, state.password.value, context);
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

final registerformProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>(
        (ref) {
  final registerUserCallback = ref.watch(authProvider.notifier).registerUser;
  return RegisterFormNotifier(registerUserCallback: registerUserCallback);
});
