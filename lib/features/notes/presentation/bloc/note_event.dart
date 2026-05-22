import 'package:leaf_notes/features/notes/data/models/note_model.dart';

abstract class NoteEvent {}

class FetchNotes extends NoteEvent{}

class GetNote extends NoteEvent{
  final String id;
  GetNote(this.id);
}

class AddNote extends NoteEvent{
  final Note newNote;
  AddNote(this.newNote);
}

class UpdateNote extends NoteEvent{
  final Note updatedNote;
  UpdateNote(this.updatedNote);
}

class NoteLock extends NoteEvent{
  final String id;
  final bool isLocked;
  NoteLock(this.id, this.isLocked);
}

class DeleteNote extends NoteEvent{
  final String id;
  DeleteNote(this.id);
}

class ClearNotes extends NoteEvent{}