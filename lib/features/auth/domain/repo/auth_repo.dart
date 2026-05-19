import 'package:leaf_notes/features/auth/data/model/app_user.dart';

abstract class AuthRepo {
  Future<AppUser?> loginWithEmailPassword(String email, String password);
  Future<AppUser?> registerWithEmailPassword(String email, String password, String username);
  Future<void> logout();
  Future<AppUser?> getCurrentUser();
  Future<void> deleteAccount();
}