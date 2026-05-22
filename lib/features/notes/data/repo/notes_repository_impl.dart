import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:leaf_notes/features/notes/data/models/note_model.dart';
import 'package:leaf_notes/features/notes/domain/repo/notes_repository.dart';

class NotesRepositoryImpl implements NotesRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String get userId {
    final uid = firebaseAuth.currentUser?.uid;
    if(uid == null) throw Exception("User not Authenticated");
    return uid;
  }

  CollectionReference<Map<String, dynamic>> get _notesCollection =>
      firestore.collection('users').doc(userId).collection('notes');

  @override
  Future<List<Note>> getNotes() async {
    try {
      final snapshot = await _notesCollection
          .orderBy('updatedAt', descending: true)
          .get();

      final notes = snapshot.docs
          .map((doc) => Note.fromJson({'id': doc.id, ...doc.data()}))
          .toList();
      return notes;
    } on FirebaseException {
      rethrow;
    }
  }

  @override
  Future<Note?> getNoteById(String id) async {
    try {
      final doc = await _notesCollection.doc(id).get();

      if (!doc.exists || doc.data() == null) return null;

      return Note.fromJson({'id': doc.id, ...doc.data()!});
    } on FirebaseException {
      rethrow;
    }
  }

  @override
  Future<Note> addNote(Note note) async {
    try {
      final docref = _notesCollection.doc();

      final newNote = note.copyWith(
        id: docref.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await docref.set(newNote.toJson());
      return newNote;
    } on FirebaseException {
      rethrow;
    }
  }

  @override
  Future<Note> updateNote(Note note) async {
    try {
      final docref = _notesCollection.doc(note.id);

      final updatedNote = note.copyWith(updatedAt: DateTime.now());

      await docref.update(updatedNote.toJson());
      return updatedNote;
    } on FirebaseException {
      rethrow;
    }
  }

  @override
  Future<void> setLock(String id, {required bool isLocked}) async {
    try {
      await _notesCollection.doc(id).update({'isLocked': isLocked});
    } on FirebaseException {
      rethrow;
    }
  }

  @override
  Future<bool> deleteNote(String id) async {
    try {
      await _notesCollection.doc(id).delete();
      return true;
    } on FirebaseException catch (e) {
      if (e.code == "not-found") return false;
      rethrow;
    }
  }
}
