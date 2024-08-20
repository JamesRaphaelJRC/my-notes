// import 'dart:developer' show log;
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';
import 'package:mynotes/utilities/navigate_user_to.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // define the controllers for email and password
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    // creates these 2 vars creating the register page
    // instantiate the controllers in state when pg loads
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // dispose them when the page dies
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Enter your email"),
          ),
          TextField(
            controller: _password,
            decoration: const InputDecoration(hintText: "Enter your password"),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                log('Logging in');
                await AuthService.firebase().login(
                  email: email,
                  password: password,
                );
                log('DOne Logging in');
                // get latest user object
                final currentUser = AuthService.firebase().currentUser;
                if (currentUser?.isEmailVerified ?? false) {
                  log('sending to notes');
                  navigateTo(
                    route: notesRoute,
                    allowBackNavigation: false,
                  );
                } else {
                  log('sending to verify');
                  navigateTo(
                    route: verifyEmailRoute,
                    allowBackNavigation: false,
                  );
                }
              } on InvalidCredentialsAuthException {
                await showErrorDialog('Invalid credentials');
              } on GenericAuthException {
                await showErrorDialog('An unexpected error occurred');
              }
            },
            child: const Text("Login"),
          ),
          TextButton(
              onPressed: () {
                navigateTo(
                  route: registerRoute,
                  allowBackNavigation: true,
                );
              },
              child: const Text('Not registered? Register here!'))
        ],
      ),
    );
  }
}
