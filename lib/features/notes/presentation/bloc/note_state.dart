import 'package:leaf_notes/features/notes/data/models/note_model.dart';

enum NoteStatus { initial, loading, success, failure }

class NoteState {
  final NoteStatus status;
  final NoteStatus selectedNoteStatus;
  final List<Note> notes;
  final Note? selectedNote;
  final String? errorMessage;

  NoteState({
    this.status = NoteStatus.initial,
    this.selectedNoteStatus = NoteStatus.initial,
    this.notes = const [],
    this.selectedNote,
    this.errorMessage,
  });

  NoteState copyWith({
    NoteStatus? status,
    NoteStatus? selectedNoteStatus,
    List<Note>? notes,
    Note? selectedNote,
    String? errorMessage,
  }) {
    return NoteState(
      status: status ?? this.status,
      selectedNoteStatus: selectedNoteStatus ?? this.selectedNoteStatus,
      notes: notes ?? this.notes,
      selectedNote: selectedNote ?? this.selectedNote,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
