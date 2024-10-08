import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
// import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/utilities/dialogs/logout_dialog.dart';
import 'package:mynotes/utilities/navigate_user_to.dart';
import 'package:mynotes/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  // String get userEmail => AuthService.firebase().currentUser!.email;
  String get userId => AuthService.firebase().currentUser!.id;
  // late final NotesService _notesService;
  late final FirebaseCloudStorage _notesService;

  @override
  void initState() {
    // instantiate a NoteService during the rendering of this
    // widget
    // _notesService = NotesService();
    _notesService = FirebaseCloudStorage();
    super.initState();
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
                  navigateTo(
                    route: createOrUpdateNoteRoute,
                    allowBackNavigation: true,
                  );
                },
                icon: const Icon(Icons.add)),
            PopupMenuButton<MenuAction>(
              // onSelected is called when a menu item is clicked
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    // when logout is clicked, show the dialog and await response
                    final shouldLogout = await showLogoutDialog();
                    if (context.mounted && shouldLogout) {
                      context.read<AuthBloc>().add(const AuthEventLogout());
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
        body: StreamBuilder(
          stream: _notesService.allNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: // leave empty i.e. fall true
              case ConnectionState.active:
                // when 1 note has been created/returned it changes to
                // active
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  return NotesListView(
                    notes: allNotes,
                    onDeleteNote: (note) async {
                      await _notesService.deleteNote(
                          documentId: note.documentId);
                    },
                    onTap: (note) {
                      navigateTo(
                        route: createOrUpdateNoteRoute,
                        allowBackNavigation: true,
                        arguments: note,
                      );
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }

              case ConnectionState.done:
                return const Text("here are the notes");
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}

// for notes local db feature
      // body: FutureBuilder(
      //   // ensures user is created in the db
      //   future: _notesService.getOrCreateUser(email: userEmail),
      //   builder: (context, snapshot) {
      //     // snapshot is the returned value from the future function
      //     switch (snapshot.connectionState) {
      //       case ConnectionState.done:
      //         if (snapshot.hasError) {
      //           return Text('Error: ${snapshot.error}');
      //         } else if (snapshot.hasData) {
      //           return StreamBuilder(
      //             stream: _notesService.allNotes,
      //             builder: (context, snapshot) {
      //               switch (snapshot.connectionState) {
      //                 case ConnectionState
      //                       .waiting: // leave empty i.e. fall true
      //                 case ConnectionState.active:
      //                   // when 1 note has been created/returned it changes to
      //                   // active
      //                   if (snapshot.hasData) {
      //                     final allNotes = snapshot.data as List<DatabaseNote>;
      //                     return NotesListView(
      //                       notes: allNotes,
      //                       onDeleteNote: (note) async {
      //                         await _notesService.deleteNote(id: note.id);
      //                       },
      //                       onTap: (note) {
      //                         navigateTo(
      //                           route: createOrUpdateNoteRoute,
      //                           allowBackNavigation: true,
      //                           arguments: note,
      //                         );
      //                       },
      //                     );
      //                   } else {
      //                     return const CircularProgressIndicator();
      //                   }

      //                 case ConnectionState.done:
      //                   return const Text("here are the notes");
      //                 default:
      //                   return const CircularProgressIndicator();
      //               }
      //             },
      //           );
      //         } else {
      //           return const Text('User does not exist in the database');
      //         }
      //       default:
      //         return const CircularProgressIndicator();
      //     }
      //   },
      // ),