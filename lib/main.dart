import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_notes/features/auth/data/repo/auth_repo_impl.dart';
import 'package:leaf_notes/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:leaf_notes/features/auth/presentation/bloc/auth_event.dart';
import 'package:leaf_notes/features/auth/presentation/bloc/auth_state.dart';
import 'package:leaf_notes/features/notes/data/repo/notes_repository_impl.dart';
import 'package:leaf_notes/features/notes/presentation/bloc/note_bloc.dart';
import 'package:leaf_notes/firebase_options.dart';
import 'package:leaf_notes/features/auth/presentation/pages/auth_page.dart';
import 'package:leaf_notes/features/notes/presentation/pages/home_page.dart';
import 'package:leaf_notes/presentation/pages/intro_page.dart';
import 'package:leaf_notes/themes/light_theme.dart';
// import 'package:leaf_notes/presentation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final AuthRepoImpl authRepo = AuthRepoImpl();
  final NotesRepositoryImpl noteRepo = NotesRepositoryImpl();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(authRepo)..add(CheckAuth())),
        BlocProvider(create: (context) => NoteBloc(noteRepo)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: LightTheme.theme,
      home: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (previous, current) => current is! AuthError,
        builder: (context, state) {
          if (state is AuthIntro) {
            return const IntroPage();
          }
          if (state is Authenticated) {
            return const HomePage();
          } else if (state is Unauthenticated) {
            if (context.mounted) {
              return const AuthPage();
            }
          }
          return const AuthPage();
        },
      ),
    );
  }
}
