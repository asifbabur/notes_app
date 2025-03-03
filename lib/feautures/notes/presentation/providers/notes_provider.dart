import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_notes_flutter/feautures/notes/data/models/note.dart';
import 'package:my_notes_flutter/feautures/notes/data/source/notes_data_source.dart';
import 'package:my_notes_flutter/feautures/notes/domain/repositories/notes_repo_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'notes_provider.g.dart';

// Provider for the FirebaseNotesDataSource
@Riverpod(keepAlive: true)
FirebaseNotesDataSource firebaseNotesDataSource(Ref ref) {
  return FirebaseNotesDataSource();
}

// Provider for the NotesRepository
@Riverpod(keepAlive: true)
NotesRepositoryImpl notesRepository(Ref ref) {
  final dataSource = ref.watch(firebaseNotesDataSourceProvider);
  return NotesRepositoryImpl(dataSource: dataSource);
}

// AsyncNotifier for managing the notes list (fetching, updating state, etc.)
@Riverpod(keepAlive: true)
class NotesController extends _$NotesController {
  @override
  FutureOr<List<Note>> build() async {
    // Initially load notes
    return await ref.read(notesRepositoryProvider).getNotes().first;
  }

  // Method to add a new note
  Future<void> addNote(Note note) async {
    await ref.read(notesRepositoryProvider).createNote(note);
    state = AsyncValue.data(await ref.read(notesRepositoryProvider).getNotes().first);
  }

  // Method to update an existing note
  Future<void> updateNote(Note note) async {
    await ref.read(notesRepositoryProvider).updateNote(note);
    state = AsyncValue.data(await ref.read(notesRepositoryProvider).getNotes().first);
  }

  // Method to delete a note
  Future<void> deleteNote(String noteId) async {
    await ref.read(notesRepositoryProvider).deleteNote(noteId);
    state = AsyncValue.data(await ref.read(notesRepositoryProvider).getNotes().first);
  }
}
