import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' show log;

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
                UserCredential userCredential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email, password: password);
                log(userCredential.toString());
                redirectToHomePage();
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  log('No user found for that email.');
                } else if (e.code == 'wrong-password') {
                  log('Wrong password provided for that user.');
                }
              }
            },
            child: const Text("Login"),
          ),
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Not registered? Register here!'))
        ],
      ),
    );
  }

  void redirectToHomePage() {
    Navigator.popAndPushNamed(context, '/');
  }
}
