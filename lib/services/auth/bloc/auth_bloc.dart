import 'package:bloc/bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // needs a provider, with init state being AuthStateLoading
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    // initialize
    on<AuthEventInitialize>(
      (event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;

        // provider is initialized but no user meaning user is logged out
        if (user == null) {
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        } else if (!user.isEmailVerified) {
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        }
      },
    );
    // handle send email verification
    on<AuthEventSendEmailVerification>(
      (event, emit) async {
        await provider.sendEmailVerification();
        // emit same state since its just to send email so nothing changed
        emit(state);
      },
    );
    // Register
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;

      try {
        await provider.createUser(email: email, password: password);
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(exception: e, isLoading: false));
      }
    });
    // login
    on<AuthEventLogin>(
      (event, emit) async {
        emit(const AuthStateLoggedOut(
            exception: null,
            isLoading: true,
            loadingText: 'Please wait while I log you in'));

        final email = event.email;
        final password = event.password;
        try {
          // emit(const AuthStateLoading());
          final user = await provider.login(email: email, password: password);
          if (!user.isEmailVerified) {
            emit(const AuthStateLoggedOut(exception: null, isLoading: false));
            emit(const AuthStateNeedsVerification(isLoading: false));
          } else {
            // disable loading
            emit(const AuthStateLoggedOut(exception: null, isLoading: false));
            emit(AuthStateLoggedIn(user: user, isLoading: false));
          }
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e, isLoading: false));
        }
      },
    );

    on<AuthEventShouldRegister>(
      (event, emit) {
        emit(const AuthStateRegistering(isLoading: false));
      },
    );

    // forgot password
    on<AuthEventForgotPassword>(
      (event, emit) async {
        emit(const AuthStateForgotPassword(
          isLoading: false,
          exception: null,
          hasSentEmail: false,
        ));
        final email = event.email;
        if (email == null) {
          // user wants to go to forgot password screen
          return;
        }
        // user wants to send a rest password email
        emit(const AuthStateForgotPassword(
          isLoading: true,
          exception: null,
          hasSentEmail: false,
        ));

        bool didSendEmail;
        Exception? exception;

        try {
          await provider.sendPasswordReset(email: email);
          didSendEmail = true;
          exception = null;
        } on Exception catch (e) {
          didSendEmail = false;
          exception = e;
        }

        emit(AuthStateForgotPassword(
          isLoading: false,
          exception: exception,
          hasSentEmail: didSendEmail,
        ));
      },
    );

    //logout
    on<AuthEventLogout>(
      (event, emit) async {
        try {
          await provider.logout();
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e, isLoading: false));
        }
      },
    );
  }
}
