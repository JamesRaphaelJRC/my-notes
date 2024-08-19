import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T> Function();

// return is generic, true, false, null
Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder,
}) {
  final options = optionsBuilder();

  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: options.keys.map((optionTitle) {
          final value = options[optionTitle];
          return TextButton(
            onPressed: () {
              if (value != null) {
                // will return the value could be true or false
                Navigator.of(context).pop(value);
              } else {
                // used in a dialog that just dismisses the dialog, like ok
                // returns null
                Navigator.of(context).pop();
              }
            },
            child: Text(optionTitle),
          );
        }).toList(),
      );
    },
  );
}
