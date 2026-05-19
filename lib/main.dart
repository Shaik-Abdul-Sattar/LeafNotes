import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_notes/features/auth/data/repo/auth_repo_impl.dart';
import 'package:leaf_notes/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:leaf_notes/features/auth/presentation/bloc/auth_event.dart';
import 'package:leaf_notes/features/auth/presentation/bloc/auth_state.dart';
import 'package:leaf_notes/firebase_options.dart';
import 'package:leaf_notes/features/auth/presentation/pages/auth_page.dart';
import 'package:leaf_notes/presentation/pages/home_page.dart';
// import 'package:leaf_notes/presentation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final AuthRepoImpl authRepo = AuthRepoImpl();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(authRepo)..add(CheckAuth())),
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
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return const HomePage();
          } 
          
          else if (state is Unauthenticated) {
            return const AuthPage();
          }

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
