// get only User class from the package
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;

  const AuthUser({required this.isEmailVerified});
  
  // Factory constructor to create an AuthUser instance from a Firebase User
  // fromFirebase is like a method of AuthUser class
  factory AuthUser.fromFirebase(User user) =>
      AuthUser(isEmailVerified: user.emailVerified);
}
