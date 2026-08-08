import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:leaf_notes/core/constants/app_icons.dart';
import 'package:leaf_notes/core/widgets/app_icon.dart';
import 'package:leaf_notes/features/notes/data/models/note_model.dart';
import 'package:leaf_notes/features/notes/presentation/bloc/note_bloc.dart';
import 'package:leaf_notes/features/notes/presentation/bloc/note_event.dart';
import 'package:leaf_notes/features/notes/presentation/bloc/note_state.dart';
import 'package:leaf_notes/features/notes/presentation/components/dialog_box.dart';
import 'package:leaf_notes/features/notes/presentation/components/note_menu_button.dart';
import 'package:leaf_notes/features/notes/presentation/components/note_textfield.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AddNotePage extends StatefulWidget {
  final Note? note;
  const AddNotePage({super.key, this.note});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  Note? _currentNote;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final FocusNode titleFocus = FocusNode();
  final FocusNode contentFocus = FocusNode();
  bool lockNote = false;
  bool isFavourite = false;
  DateTime date = DateTime.now();
  bool isEditing = true;

  final List<String> emotions = [
    AppIcons.happy,
    AppIcons.sad,
    AppIcons.cry,
    AppIcons.tired,
    AppIcons.dizzy,
    AppIcons.angry,
  ];
  String selectedMood = '';

  void addnote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final deltaContent = Delta()
      ..insert(content)
      ..insert('\n');

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please write a title."),
          margin: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
        ),
      );
      return;
    }
    if (_currentNote == null) {
      context.read<NoteBloc>().add(
        AddNote(
          Note(
            title: title,
            content: deltaContent,
            isLocked: lockNote,
            mood: selectedMood,
            isFavourite: isFavourite,
            createdAt: DateTime.now(),
          ),
        ),
      );
    } else {
      context.read<NoteBloc>().add(
        UpdateNote(
          _currentNote!.copyWith(
            title: title,
            content: deltaContent,
            isLocked: lockNote,
            isFavourite: isFavourite,
            mood: selectedMood,
          ),
        ),
      );
    }
  }

  void onLock() {
    setState(() => lockNote = !lockNote);
  }

  void onDelete() {
    if (_currentNote == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please save the note first."),
          margin: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) =>
          DialogBox(note: _currentNote!.title, id: _currentNote!.id),
    );
  }

  @override
  void initState() {
    super.initState();
    _currentNote = widget.note;

    if (_currentNote == null) return;

    isEditing = false;

    _titleController.text = _currentNote!.title;
    final json = _currentNote!.content;
    _contentController.text = ParchmentDocument.fromDelta(json).toPlainText();
    lockNote = _currentNote!.isLocked;
    isFavourite = _currentNote!.isFavourite;
    selectedMood = _currentNote!.mood;
    date = _currentNote!.createdAt;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    titleFocus.dispose();
    contentFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE, dd MMMM.').format(date);
    return BlocListener<NoteBloc, NoteState>(
      listener: (context, state) {
        if (state.selectedNoteStatus == NoteStatus.deleted) {
          Navigator.pop(context);
        }
        if (state.selectedNoteStatus == NoteStatus.added &&
            _currentNote == null) {
          setState(() {
            _currentNote = state.selectedNote;
          });
        }

        if (state.selectedNoteStatus == NoteStatus.success ||
            state.selectedNoteStatus == NoteStatus.added) {
          setState(() {
            isEditing = false;
          });
        }
        if (state.selectedNoteStatus == NoteStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage.toString())),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFEBF5FB),
        appBar: AppBar(
          backgroundColor: const Color(0xFFEBF5FB),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),

          title: Text(
            _currentNote == null ? 'New Diary' : _currentNote!.title,
            style: const TextStyle(
              color: Color(0xFF0D3B5C),
              fontFamily: 'PlusJakartaSans',
              fontSize: 22,
              fontWeight: FontWeight.w300,
            ),
          ),
          actions: [
            isEditing
                ? GestureDetector(
                    onTap: () {
                      addnote();
                    },
                    child: BlocBuilder<NoteBloc, NoteState>(
                      builder: (context, state) {
                        final isSaving =
                            state.selectedNoteStatus == NoteStatus.saving;
                        return Container(
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: const Color(0xFF5B5BD6),
                          ),
                          child: isSaving
                              ? LoadingAnimationWidget.fourRotatingDots(
                                  color: Colors.white,
                                  size: 15,
                                )
                              : const Center(
                                  child: Text(
                                    "Save",
                                    style: TextStyle(
                                      fontFamily: 'ManRope',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        );
                      },
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      setState(() => isEditing = !isEditing);
                    },
                    icon: const AppIcon(iconName: AppIcons.edit),
                  ),
            const SizedBox(width: 5),

            NoteMenuButton(
              onDelete: onDelete,
              onLock: onLock,
              parentContext: context,
            ),
            const SizedBox(width: 10),
          ],
        ),

        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
              top: 5,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        height: 40,
                        // width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            formattedDate,
                            style: const TextStyle(
                              color: Color(0xFF0D3B5C),
                              fontSize: 20,
                              fontFamily: 'ManRope',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // SizedBox(width: MediaQuery.of(context).size.width * 0.150),
                    IconButton(
                      onPressed: () {
                        if (isEditing) {
                          setState(() => isFavourite = !isFavourite);
                        }
                      },
                      icon: Icon(
                        isFavourite
                            ? Icons.favorite_outlined
                            : Icons.favorite_outline,
                        color: isFavourite ? const Color(0xFFE56B7A) : null,
                        size: 30,
                      ),
                    ),

                    // const SizedBox(width: 10),
                    // AppIcon(
                    //   iconName: lockNote ? AppIcons.lock : AppIcons.lockOpen,
                    //   size: 30,
                    // ),
                  ],
                ),
                NoteTextfield(
                  controller: _titleController,
                  hintText: "Title...",
                  isTitle: true,
                  focusNode: titleFocus,
                  readOnly: !isEditing,
                ),
                // const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Mood:  ',
                        style: TextStyle(
                          color: Color(0xFF0D3B5C),
                          fontSize: 20,
                          fontFamily: 'ManRope',
                        ),
                      ),
                      Container(
                        height: 45,
                        width: MediaQuery.of(context).size.height * 0.260,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: emotions.map((emotion) {
                            return GestureDetector(
                              onTap: () {
                                if (isEditing) {
                                  setState(() {
                                    selectedMood = emotion;
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selectedMood == emotion
                                      ? const Color.fromARGB(255, 181, 224, 253)
                                      : null,
                                  borderRadius: BorderRadius.circular(50),
                                ),

                                child: AppIcon(iconName: emotion, size: 30),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: NoteTextfield(
                    controller: _contentController,
                    hintText: "Start writing here..",
                    isTitle: false,
                    focusNode: contentFocus,
                    readOnly: !isEditing,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
