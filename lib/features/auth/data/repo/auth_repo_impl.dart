import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:leaf_notes/features/auth/data/model/app_user.dart';
import 'package:leaf_notes/features/auth/domain/repo/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      //sign in and update firebase auth and returns the user data like uid, email, phoneno etc
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;

      //fetch user document from firestore, it contains data, metadata, document id
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      final appuser = AppUser.fromJSON(
        userDoc.data()!,
      ); // userdoc.data returns a map. formJSON converts to object
      return appuser;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
    String email,
    String password,
    String username,
  ) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;

      final appuser = AppUser(uid: uid, email: email, username: username);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(appuser.toJSON());

      return appuser;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists || userDoc.data() == null) return null;

    final appuser = AppUser.fromJSON(userDoc.data()!);
    return appuser;
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> deleteAccount() async {
    final user = firebaseAuth.currentUser;
    if (user == null) throw Exception('No user logged in.');

    await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
    await user.delete();
    // await logout();
  }
}
