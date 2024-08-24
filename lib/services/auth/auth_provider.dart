import 'package:mynotes/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();

  // getter to return current user
  AuthUser? get currentUser;
  Future<AuthUser> login({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> sendEmailVerification();

  Future<void> sendPasswordReset({required String email});
}
