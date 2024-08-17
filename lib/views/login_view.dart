// import 'dart:developer' show log;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/utilities/send_user_to.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

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
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                // get latest user object
                final currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser?.emailVerified ?? false) {
                  sendUserTo(notesRoute, false);
                } else {
                  sendUserTo(verifyEmailRoute, false);
                }
              } on FirebaseAuthException catch (e) {
                List<String> credentialErrors = [
                  'invalid-email',
                  'user-not-found',
                  'wrong-password',
                  'invalid-credential',
                ];
                if (credentialErrors.contains(e.code)) {
                  await showErrorDialog('Invalid credentials');
                } else {
                  await showErrorDialog(
                    'An unknown error occurred.',
                  );
                }
              } catch (e) {
                await showErrorDialog('An unexpected error occurred');
              }
            },
            child: const Text("Login"),
          ),
          TextButton(
              onPressed: () {
                sendUserTo(registerRoute, true);
              },
              child: const Text('Not registered? Register here!'))
        ],
      ),
    );
  }
}
