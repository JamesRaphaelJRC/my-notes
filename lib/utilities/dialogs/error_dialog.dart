import 'package:mynotes/constants/material_app_consts.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(String text) {
  final context = navigatorKey.currentContext!;

  return showGenericDialog(
    context: context,
    title: "An error occurred",
    content: text,
    optionsBuilder: () => {'Ok': null},
  );
}
