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
  /// Note: semester is numeric per DB schema.
  Future<void> signup(
    String email,
    String password,
    String name,
    String department,
    int semester,
  ) async {
    // Create auth user
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Save extra user info using current user from credential
    await saveExtraUserInfo(
      uid: credential.user!.uid,
      name: name,
      email: email,
      department: department,
      semester: semester,
    );
  }

  /// Save minimal user document under `users/{uid}`.
  Future<void> saveExtraUserInfo({
    required String uid,
    required String name,
    required String email,
    required String department,
    required int semester,
    String profileImageUrl = '',
  }) async {
    final docRef = _firestore.collection('users').doc(uid);

    final data = <String, Object?>{
      'uid': uid,
      'name': name,
      'email': email,
      'department': department,
      'semester': semester,
      'profileImageUrl': profileImageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    };

    await docRef.set(data, SetOptions(merge: true));
  }
}
