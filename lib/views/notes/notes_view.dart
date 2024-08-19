import 'package:flutter/material.dart';
import 'package:mynotes/constants/material_app_consts.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/utilities/navigate_user_to.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  String get userEmail => AuthService.firebase().currentUser!.email!;
  late final NotesService _notesService;

  @override
  void initState() {
    // instantiate a NoteService during the rendering of this
    // widget
    _notesService = NotesService();
    super.initState();
  }

  @override
  void dispose() {
    // close noteservice db
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: () {
                navigateTo(newNoteRoute, true);
              },
              icon: const Icon(Icons.add)),
          PopupMenuButton<MenuAction>(
            // onSelected is called when a menu item is clicked
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  // when logout is clicked, show the dialog and await response
                  final shouldLogout = await showLogOutDialog();
                  if (mounted && shouldLogout) {
                    await AuthService.firebase().logout();
                    // Ensure the widget is still mounted before navigating
                    if (mounted) {
                      navigateTo(loginRoute, false);
                    }
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                    // value is just like value in html input and text is what
                    // user sees
                    value: MenuAction.logout,
                    child: Text('Logout'))
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder(
        // ensures user is created in the db
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          // snapshot is the returned value from the future function
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return StreamBuilder(
                  stream: _notesService.allNotes,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState
                            .waiting: // leave empty i.e. fall true
                      case ConnectionState.active:
                      // when 1 note has been created/returned it changes to
                      // active

                      case ConnectionState.done:
                        return const Text("here are the notes");
                      default:
                        return const CircularProgressIndicator();
                    }
                  },
                );
              } else {
                return const Text('User does not exist in the database');
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

Future<bool> showLogOutDialog() {
  return showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Logout'))
        ],
      );
    },
  ).then((value) => value ?? false);
}
