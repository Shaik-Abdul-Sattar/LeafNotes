import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_notes/features/notes/data/repo/notes_repository_impl.dart';
import 'package:leaf_notes/features/notes/presentation/bloc/note_event.dart';
import 'package:leaf_notes/features/notes/presentation/bloc/note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NotesRepositoryImpl _noterepo;

  NoteBloc(this._noterepo) : super(NoteState(status: NoteStatus.initial)) {
    on<FetchNotes>((event, emit) async {
      try {
        emit(state.copyWith(status: NoteStatus.loading));

        final notes = await _noterepo.getNotes();
        emit(state.copyWith(notes: notes, status: NoteStatus.success));
      } on FirebaseException catch (e) {
        emit(
          state.copyWith(status: NoteStatus.failure, errorMessage: e.message),
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: NoteStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    });

    on<GetNote>((event, emit) async {
      try {
        emit(state.copyWith(selectedNoteStatus: NoteStatus.loading));

        final note = await _noterepo.getNoteById(event.id);

        if (note != null) {
          emit(
            state.copyWith(
              selectedNote: note,
              selectedNoteStatus: NoteStatus.success,
            ),
          );
        } else {
          emit(
            state.copyWith(
              selectedNoteStatus: NoteStatus.failure,
              errorMessage: "The note does not exist",
            ),
          );
        }
      } on FirebaseException catch (e) {
        emit(
          state.copyWith(
            selectedNoteStatus: NoteStatus.failure,
            errorMessage: e.message,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            selectedNoteStatus: NoteStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    });

    on<AddNote>((event, emit) async {
      try {
        emit(state.copyWith(selectedNoteStatus: NoteStatus.saving));
        final note = await _noterepo.addNote(event.newNote);
        emit(
          state.copyWith(
            selectedNote: note,
            notes: [note, ...state.notes],
            selectedNoteStatus: NoteStatus.added,
          ),
        );
      } on TimeoutException {
        emit(
          state.copyWith(
            selectedNoteStatus: NoteStatus.failure,
            errorMessage: 'No internet connection. Please try again.',
          ),
        );
      } on FirebaseException catch (e) {
        emit(
          state.copyWith(
            selectedNoteStatus: NoteStatus.failure,
            errorMessage: e.message,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            selectedNoteStatus: NoteStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    });

    on<UpdateNote>((event, emit) async {
      try {
        emit(state.copyWith(selectedNoteStatus: NoteStatus.saving));

        await _noterepo.updateNote(event.updatedNote);
        final notes = state.notes
            .map(
              (note) =>
                  note.id == event.updatedNote.id ? event.updatedNote : note,
            )
            .toList();
        emit(
          state.copyWith(notes: notes, selectedNoteStatus: NoteStatus.success),
        );
      } on TimeoutException {
        emit(
          state.copyWith(
            selectedNoteStatus: NoteStatus.failure,
            errorMessage: 'No internet connection. Please try again.',
          ),
        );
      } on FirebaseException catch (e) {
        emit(
          state.copyWith(
            selectedNoteStatus: NoteStatus.failure,
            errorMessage: e.message,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            selectedNoteStatus: NoteStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    });

    on<NoteLock>((event, emit) async {
      try {
        emit(state.copyWith(selectedNoteStatus: NoteStatus.loading));

        await _noterepo.setLock(event.id, isLocked: event.isLocked);

        final notes = state.notes
            .map(
              (note) => note.id == event.id
                  ? note.copyWith(isLocked: event.isLocked)
                  : note,
            )
            .toList();

        emit(
          state.copyWith(notes: notes, selectedNoteStatus: NoteStatus.success),
        );
      } on FirebaseException catch (e) {
        emit(
          state.copyWith(
            selectedNoteStatus: NoteStatus.failure,
            errorMessage: e.message,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            selectedNoteStatus: NoteStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    });

    on<DeleteNote>((event, emit) async {
      try {
        emit(state.copyWith(selectedNoteStatus: NoteStatus.loading));

        final isDeleted = await _noterepo.deleteNote(event.id);

        if (isDeleted) {
          final notes = state.notes
              .where((note) => note.id != event.id)
              .toList();
          emit(
            state.copyWith(
              notes: notes,
              selectedNoteStatus: NoteStatus.deleted,
            ),
          );
        } else {
          emit(
            state.copyWith(
              selectedNoteStatus: NoteStatus.failure,
              errorMessage: "Failed to delete the note",
            ),
          );
        }
      } on FirebaseException catch (e) {
        emit(
          state.copyWith(
            selectedNoteStatus: NoteStatus.failure,
            errorMessage: e.message,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            selectedNoteStatus: NoteStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    });

    on<ToggleNoteSelection>((event, emit) {
      final selectedDeleteNotes = Set<String>.from(state.selectedNotes);

      if (selectedDeleteNotes.contains(event.noteId)) {
        selectedDeleteNotes.remove(event.noteId);
      } else {
        selectedDeleteNotes.add(event.noteId);
      }

      emit(state.copyWith(selectedNotes: selectedDeleteNotes));
      print(state.selectedNotes);
    });

    on<DeleteSelectedNotes>((event, emit) async {
      try {
        emit(state.copyWith(status: NoteStatus.loading));
        for (final id in state.selectedNotes) {
          await _noterepo.deleteNote(id);
        }

        final updatedNotes = state.notes
            .where((note) => !state.selectedNotes.contains(note.id))
            .toList();

        emit(
          state.copyWith(
            notes: updatedNotes,
            selectedNotes: {},
            status: NoteStatus.deleted,
          ),
        );
      } on FirebaseException catch (e) {
        emit(
          state.copyWith(
            selectedNoteStatus: NoteStatus.failure,
            errorMessage: e.message,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            selectedNoteStatus: NoteStatus.failure,
            errorMessage: "Failed to Delete the notes.",
          ),
        );
      }
    });

    on<ClearSelectedNotes>((event, emit) {
      emit(state.copyWith(selectedNotes: {}));
    });

    on<ClearNotes>((event, emit) {
      emit(state.copyWith(notes: [], status: NoteStatus.success));
    });
  }
}
