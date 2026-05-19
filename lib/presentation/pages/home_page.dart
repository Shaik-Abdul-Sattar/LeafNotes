import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_notes/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:leaf_notes/features/auth/presentation/bloc/auth_event.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(child: Text("welcome")),
    );
  }
}
