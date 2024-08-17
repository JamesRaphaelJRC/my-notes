import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/navigate_user_to.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Column(
        children: [
          const Text(
              "We've just sent you a verification email, please open it to "
              "verify your account"),
          const Text("Haven't received it yet? press the button below"),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
              },
              child: const Text('Resend verification email')),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().logout();
                navigateTo(registerRoute, false);
              },
              child: const Text('Restart'))
        ],
      ),
    );
  }
}
