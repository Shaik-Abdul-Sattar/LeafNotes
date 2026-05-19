import 'package:leaf_notes/features/auth/data/model/app_user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState{}

class AuthLoading extends AuthState{}

class Authenticated extends AuthState{
  final AppUser appuser;
  Authenticated(this.appuser);
}

class Unauthenticated extends AuthState{}

class AuthError extends AuthState{
  final String message;
  AuthError(this.message);
}