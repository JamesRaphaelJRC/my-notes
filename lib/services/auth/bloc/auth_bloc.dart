import 'package:bloc/bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // needs a provider, with init state being AuthStateLoading
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    // handle events here

    // initialize
    on<AuthEventInitialize>(
      (event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;

        // provider is initialized but no user meaning user is logged out
        if (user == null) {
          emit(const AuthStateLoggedOut(null));
        } else if (!user.isEmailVerified) {
          emit(const AuthStateNeedsVerification());
        } else {
          emit(AuthStateLoggedIn(user: user));
        }
      },
    );
    // login
    on<AuthEventLogin>(
      (event, emit) async {
        final email = event.email;
        final password = event.password;

        try {
          // emit(const AuthStateLoading());
          final user = await provider.login(email: email, password: password);
          emit(AuthStateLoggedIn(user: user));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(e));
        }
      },
    );

    //logout
    on<AuthEventLogout>(
      (event, emit) async {
        try {
          emit(const AuthStateLoading());
          await provider.logout();
          emit(const AuthStateLoggedOut(null));
        } on Exception catch (e) {
          emit(AuthStateLoggedOutFailure(exception: e));
        }
      },
    );
  }
}
