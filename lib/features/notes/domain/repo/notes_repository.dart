import 'package:leaf_notes/features/notes/data/models/note_model.dart';

abstract class NotesRepository {
  Future<Note> addNote(Note note);
  Future<Note> updateNote(Note note);
  Future<bool> deleteNote(String id);
  Future<List<Note>> getNotes();
  Future<Note?> getNoteById(String id);
  Future<void> setLock(String id, {required bool isLocked});
}