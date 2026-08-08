import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_notes/features/notes/presentation/bloc/note_bloc.dart';
import 'package:leaf_notes/features/notes/presentation/bloc/note_event.dart';

class DialogBox extends StatelessWidget {
  final String note;
  final String id;
  const DialogBox({
    super.key,
    required this.note,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Delete Diary?', textAlign: TextAlign.center),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.delete_outline,
              color: Colors.red.shade600,
              size: 26,
            ),
          ),
        ],
      ),
      content: Text(
        'This will permanently delete "$note". This action cannot be undone.',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.red.shade600),
          onPressed: () {
            context.read<NoteBloc>().add(DeleteNote(id));
            Navigator.pop(context);
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
