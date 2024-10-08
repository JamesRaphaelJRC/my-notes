// get only User class from the package
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final String id;
  final bool isEmailVerified;
  final String email;

  const AuthUser(
      {required this.id, required this.isEmailVerified, required this.email});

  // Factory constructor to create an AuthUser instance from a Firebase User
  // fromFirebase is like a method of AuthUser class
  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
      );
}
