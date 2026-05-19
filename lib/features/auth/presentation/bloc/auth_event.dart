abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String username;
  RegisterRequested(this.email, this.password, this.username);
}

class CurrentUserRequested extends AuthEvent {}

class LogoutRequested extends AuthEvent {}

class AccountDeletionRequested extends AuthEvent {}

class CheckAuth extends AuthEvent {}

class AuthValidationFailed extends AuthEvent{}