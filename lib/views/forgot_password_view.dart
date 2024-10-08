import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';
import 'package:mynotes/utilities/dialogs/password_reset_email_sent_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            String errorMsg;
            if (state.exception is UserNotFoundAuthException) {
              errorMsg = """We could not process your request. Please"""
                  """ ensure you gave the correct email""";
            } else if (state.exception is InvalidEmailAuthException) {
              errorMsg = 'Please provide a valid email';
            } else {
              errorMsg = '''Unable to send email, please try again or contact'''
                  ''' the administrator''';
            }
            await showErrorDialog(errorMsg);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Forgot Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            const Text(
              'If you forgot your password, simply enter your email and we will send you a password reset link',
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              autofocus: true,
              controller: _controller,
              decoration: const InputDecoration(hintText: 'Your email address'),
            ),
            TextButton(
                onPressed: () {
                  final email = _controller.text;
                  context
                      .read<AuthBloc>()
                      .add((AuthEventForgotPassword(email)));
                },
                child: const Text('Send password reset link')),
            TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogout());
                },
                child: const Text('Back to login page')),
          ]),
        ),
      ),
    );
  }
}
