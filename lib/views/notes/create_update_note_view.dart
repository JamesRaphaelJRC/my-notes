import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
// import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/utilities/generics/get_arguments.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  // DatabaseNote? _note;
  // late final NotesService _notesService;
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    // _notesService = NotesService();
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // implement deletion of the empty created note if note is empty
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextIsNotEmppty();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _textControllerListener() async {
    final note = _note;
    if (note == null) return;

    final text = _textController.text;
    // await _notesService.updateNote(note: note, text: text);
    await _notesService.updateNote(
      documentId: note.documentId,
      text: text,
    );
  }

  /// removes the listener if added and readds again
  void _setUpTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  // Future<DatabaseNote> createOrGetExistingNote(BuildContext context) async {
  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    // checks if a note is passed as a param to this view/widget
    // used when user clicks on a note to update or view if in full
    // final widgetNote = context.getArgument<DatabaseNote>();
    final widgetNote = context.getArgument<CloudNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) return existingNote;

    // user cannot end up in this view without currentUser
    final currentUser = AuthService.firebase().currentUser!;
    // final email = currentUser.email;
    // final owner = await _notesService.getUser(email: email);
    // final newNote = await _notesService.createNote(owner: owner);
    final userId = currentUser.id;
    final newNote = await _notesService.createNewNote(ownerUserId: userId);
    _note = newNote;
    return newNote;
  }

  /// Ensures back and forth navigation from notes_view to this view does not
  /// create multiple empty notes
  void _deleteNoteIfTextIsEmpty() {
    final note = _note;

    if (_textController.text.isEmpty && note != null) {
      // _notesService.deleteNote(id: note.id);
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  Future<void> _saveNoteIfTextIsNotEmppty() async {
    final note = _note;
    final text = _textController.text;

    if (note != null && text.isNotEmpty) {
      // await _notesService.updateNote(note: note, text: text);
      await _notesService.updateNote(documentId: note.documentId, text: text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
        backgroundColor: Colors.blue,
      ),
      // body: FutureBuilder<DatabaseNote>(
      body: FutureBuilder<CloudNote>(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setUpTextControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                    hintText: 'Start typing your note...'),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
