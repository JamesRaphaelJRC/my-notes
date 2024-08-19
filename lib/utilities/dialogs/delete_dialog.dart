import 'package:mynotes/constants/material_app_consts.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialogue() {
  // get the context of the calling widget
  final context = navigatorKey.currentContext!;

  return showGenericDialog(
    context: context,
    title: 'Logout',
    content: 'Are you sure you want to delete this item?',
    optionsBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then((value) => value ?? false);
}
