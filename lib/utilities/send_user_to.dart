import 'package:flutter/material.dart';
import 'package:mynotes/constants/material_app_consts.dart';

/// Sends a user to a given route.
/// If allowedBackNavigation is True, pushNamed() is used else
/// pushNamedAndRemovedUntil() is used
///
void sendUserTo(String route, bool allowBackNavigation) {
  final context = navigatorKey.currentContext!;

  if (allowBackNavigation) {
    Navigator.of(context).pushNamed(route);
  } else {
    Navigator.of(context).pushNamedAndRemoveUntil(route, (_) => false);
  }
}
