import 'package:flutter/material.dart';
import 'package:mynotes/constants/material_app_consts.dart';

typedef CloseDialog = void Function();

CloseDialog showLoadingDialog({required String text}) {
  final context = navigatorKey.currentContext!;
  final dialog = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 10.0),
        Text(text)
      ],
    ),
  );

  // barrierDismissible - if click outside box should close dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => dialog,
  );

  // return a function that close the dialog
  return () => Navigator.of(context).pop();
}
