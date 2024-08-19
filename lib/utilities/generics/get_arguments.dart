import 'package:flutter/material.dart' show BuildContext, ModalRoute;

/// Adds an extension 'getArgument' to the context.
/// usage:
///   context.getArgument<T>();
extension GetArgument on BuildContext {
  /// returns all arguments passed to a widget if any or null otherwise
  T? getArgument<T>() {
    final modalRoute = ModalRoute.of(this);

    if (modalRoute != null) {
      final args = modalRoute.settings.arguments;
      if (args != null && args is T) {
        return args as T;
      }
    }
    return null;
  }
}
