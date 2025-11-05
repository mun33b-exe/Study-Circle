import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Service wrapper for Firebase Auth + minimal Firestore user setup.
class Authservices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Sign in existing user with email & password.
  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  /// Create a new user account and persist minimal user info to Firestore.
  Future<void> signup(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    // Ensure extra user info is saved after successful signup.
    await saveExtraUserInfo();
  }

  /// Save/merge minimal user document under `users/{uid}`.
  ///
  /// Uses SetOptions(merge: true) so we don't overwrite other fields if they exist.
  /// Throws a FirebaseAuthException if no current user is present.
  Future<void> saveExtraUserInfo() async {
    final user = _auth.currentUser;
    if (user == null) {
      // Defensive: should not happen immediately after signup, but handle gracefully.
      throw FirebaseAuthException(
        code: 'NO_CURRENT_USER',
        message: 'No authenticated user available to save extra info.',
      );
    }

    final uid = user.uid;

    final docRef = _firestore.collection('users').doc(uid);

    // Prepare a minimal user payload following your schema.
    final data = <String, Object?>{
      'uid': uid,
      'name': user.displayName ?? '',
      'email': user.email ?? '',
      'department': '',
      'createdAt': FieldValue.serverTimestamp(),
    };

    // Merge to avoid overwriting any pre-existing fields.
    await docRef.set(data, SetOptions(merge: true));
  }
}
