import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_notes/features/auth/data/model/app_user.dart';
import 'package:leaf_notes/features/auth/domain/repo/auth_repo.dart';
import 'package:leaf_notes/features/auth/presentation/bloc/auth_event.dart';
import 'package:leaf_notes/features/auth/presentation/bloc/auth_state.dart';
import 'package:leaf_notes/features/auth/utils/auth_exception_handler.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo authRepo;
  AppUser? _currentuser;
  AppUser? get currentuser => _currentuser;

  AuthBloc(this.authRepo) : super(AuthInitial()) {
    on<CheckAuth>((event, emit) async {
      emit(AuthLoading());
      final AppUser? user = await authRepo.getCurrentUser();

      if (user != null) {
        _currentuser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    });

    on<LoginRequested>((event, emit) async {
      try {
        emit(AuthLoading());

        final AppUser? user = await authRepo.loginWithEmailPassword(
          event.email,
          event.password,
        );
        if (user != null) {
          _currentuser = user;
          emit(Authenticated(user));
        } else {
          emit(Unauthenticated());
        }
      } on FirebaseAuthException catch (e) {
        emit(AuthError(AuthExceptionHandler.getMessage(e)));
      } catch (e) {
        emit(AuthError("Unexpected error occured"));
        // emit(Unauthenticated());
      }
    });

    on<RegisterRequested>((event, emit) async {
      try {
        emit(AuthLoading());

        final AppUser? user = await authRepo.registerWithEmailPassword(
          event.email,
          event.password,
          event.username,
        );
        if (user != null) {
          _currentuser = user;
          emit(Authenticated(user));
        }
      } on FirebaseAuthException catch (e) {
        emit(AuthError(AuthExceptionHandler.getMessage(e)));
      } catch (e) {
        emit(AuthError("Unexpected error occured"));
      }
    });

    on<LogoutRequested>((event, emit) async {
      try {
        emit(AuthLoading());
        await authRepo.logout();
        _currentuser = null;
        emit(Unauthenticated());
      } on FirebaseAuthException catch (e) {
        emit(AuthError(AuthExceptionHandler.getMessage(e)));
      } catch (e) {
        emit(AuthError("Unexpected error occured"));
        // emit(Unauthenticated());
      }
    });

    on<CurrentUserRequested>((event, emit) async {
      try {
        emit(AuthLoading());
        final AppUser? user = await authRepo.getCurrentUser();
        if (user != null) {
          _currentuser = user;
        }
      } on FirebaseAuthException catch (e) {
        emit(AuthError(AuthExceptionHandler.getMessage(e)));
      } catch (e) {
        emit(AuthError("Unexpected error occuredg"));
      }
    });

    on<AccountDeletionRequested>((event, emit) async {
      try {
        emit(AuthLoading());
        await authRepo.deleteAccount();
        _currentuser = null;
        emit(Unauthenticated());
      } on FirebaseAuthException catch (e) {
        emit(AuthError(AuthExceptionHandler.getMessage(e)));
      } catch (e) {
        emit(AuthError("Unexpected error occured"));
        // emit(Unauthenticated());
      }
    });

    on<AuthValidationFailed>((event, emit) {
      emit(AuthError("Please fill the form"));
    });
  }
}
