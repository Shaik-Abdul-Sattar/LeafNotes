import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
// import 'package:leaf_notes/core/constants/app_images.dart';
import 'package:leaf_notes/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:leaf_notes/features/auth/presentation/bloc/auth_event.dart';
import 'package:leaf_notes/features/notes/presentation/bloc/note_bloc.dart';
import 'package:leaf_notes/features/notes/presentation/bloc/note_event.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();

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
      backgroundColor: const Color(0xFFE3EEDA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE3EEDA),
        // leading: Image.asset(AppImages.appIcon),
        title: const Text(
          "  LeafNotes",
          style: TextStyle(fontFamily: 'InkFree', fontSize: 28),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}