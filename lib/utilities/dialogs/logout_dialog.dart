import 'package:mynotes/constants/material_app_consts.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogoutDialog() {
  // get the context of the calling widget
  final context = navigatorKey.currentContext!;

  return showGenericDialog(
    context: context,
    title: 'Logout',
    content: 'Do you really wish to logoout?',
    optionsBuilder: () => {
      'Cancel': false,
      'Log Out': true,
    },
  ).then((value) => value ?? false);
}
