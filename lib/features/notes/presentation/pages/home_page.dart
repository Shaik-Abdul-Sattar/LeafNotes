import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:leaf_notes/core/constants/app_icons.dart';
import 'package:leaf_notes/core/widgets/app_icon.dart';
// import 'package:leaf_notes/core/constants/app_images.dart';
import 'package:leaf_notes/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:leaf_notes/features/auth/presentation/bloc/auth_event.dart';
import 'package:leaf_notes/features/auth/presentation/bloc/auth_state.dart';
import 'package:leaf_notes/features/notes/presentation/bloc/note_bloc.dart';
import 'package:leaf_notes/features/notes/presentation/bloc/note_event.dart';
import 'package:leaf_notes/features/notes/presentation/bloc/note_state.dart';
import 'package:leaf_notes/features/notes/presentation/components/note_card.dart';
import 'package:leaf_notes/features/notes/presentation/pages/add_note_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  bool isSelecting = false;

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Morning";
    } else if (hour < 17) {
      return "Afternoon";
    } else {
      return "Evening";
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<NoteBloc>().add(FetchNotes());
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, dd MMMM, yyyy').format(now);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFE8F4FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8F4FD),
        // leading: Image.asset(AppImages.appIcon),
        title: const Text(
          "  LeafNotes",
          style: TextStyle(fontFamily: 'InkFree', fontSize: 28),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
              context.read<NoteBloc>().add(ClearNotes());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    bottom: 10,
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.130,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3AACDF),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (state is Authenticated) {
                              return Text(
                                "${_getGreeting()}, ${state.appuser.username}",
                                style: const TextStyle(
                                  fontFamily: 'ManRope',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 25,
                                ),
                              );
                            }
                            return const Text("XYZ");
                          },
                        ),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'ManRope',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 12,
                  ),
                  child: TextField(
                    controller: searchController,
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: "Search...",
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search_outlined, size: 28),
                      hintStyle: const TextStyle(
                        fontFamily: "InkFree",
                        fontSize: 18,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Diaries...",
                        style: TextStyle(
                          fontFamily: 'ManRope',
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF432E05),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 0,
                    ),
                    child: BlocBuilder<NoteBloc, NoteState>(
                      builder: (context, state) {
                        if (state.status == NoteStatus.loading) {
                          return Center(
                            child: LoadingAnimationWidget.dotsTriangle(
                              color: Colors.black,
                              size: 30,
                            ),
                          );
                        }
                        if (state.selectedNotes.isEmpty) {
                          isSelecting = false;
                        }
                        if (state.notes.isEmpty) {
                          return const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppIcon(iconName: AppIcons.note, size: 40),
                                SizedBox(height: 12),
                                Text(
                                  "No Diary entries yet.",
                                  style: TextStyle(
                                    fontFamily: 'ManRope',
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Click + to add one.",
                                  style: TextStyle(
                                    fontFamily: 'ManRope',
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(height: 30),
                              ],
                            ),
                          );
                        }
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                mainAxisExtent: 200,
                              ),
                          itemCount: state.notes.length,
                          itemBuilder: (context, index) {
                            final note = state.notes[index];
                            return GestureDetector(
                              onTap: () {
                                !isSelecting
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AddNotePage(note: note),
                                        ),
                                      )
                                    : context.read<NoteBloc>().add(
                                        ToggleNoteSelection(note.id),
                                      );
                              },
                              onLongPress: () {
                                setState(() {
                                  isSelecting = true;
                                });

                                context.read<NoteBloc>().add(
                                  ToggleNoteSelection(note.id),
                                );
                              },
                              child: NoteCard(
                                note: note,
                                isSelecting: isSelecting,
                                isSelected: state.selectedNotes.contains(
                                  note.id,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            if (isSelecting)
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.130,
                left: 0,
                right: 0,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.read<NoteBloc>().add(ClearSelectedNotes());
                          setState(() => isSelecting = false);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.cancel_outlined, size: 30),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          context.read<NoteBloc>().add(DeleteSelectedNotes());
                          setState(() => isSelecting = false);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.delete_outline,
                            color: Colors.red.shade600,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNotePage()),
          );
        },
        shape: const CircleBorder(),
        backgroundColor: const Color(0xFF1A7AB5),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
