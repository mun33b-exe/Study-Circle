import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_hub/models/user_model.dart';

class AuthService {
  AuthService()
    : _auth = FirebaseAuth.instance,
      _firestore = FirebaseFirestore.instance,
      _storage = FirebaseStorage.instance,
      _picker = ImagePicker();

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final ImagePicker _picker;

  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection('users');

  Stream<UserModel?> get currentUserStream {
    return _auth.authStateChanges().asyncExpand((firebaseUser) {
      if (firebaseUser == null) {
        return Stream<UserModel?>.value(null);
      }
      return _usersRef.doc(firebaseUser.uid).snapshots().map((snapshot) {
        if (!snapshot.exists) {
          return null;
        }
        return UserModel.fromFirestore(snapshot);
      });
    });
  }

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String department,
    required int semester,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;
    final userModel = UserModel(
      uid: uid,
      name: name,
      email: email,
      department: department,
      semester: semester,
      profileImageUrl: '',
    );

    await _usersRef.doc(uid).set(userModel.toMap());
    return credential;
  }

  Future<void> signOut() {
    return _auth.signOut();
  }

  Future<XFile?> pickImage({ImageSource source = ImageSource.gallery}) {
    return _picker.pickImage(source: source, imageQuality: 80, maxWidth: 1024);
  }

  Future<String> uploadProfileImage({
    required String uid,
    required XFile image,
  }) async {
    final file = File(image.path);
    final ref = _storage.ref().child('profile_images/$uid.jpg');
    await ref.putFile(file, SettableMetadata(contentType: 'image/jpeg'));
    return ref.getDownloadURL();
  }

  Future<void> updateUserProfile({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    await _usersRef.doc(uid).set(data, SetOptions(merge: true));
  }
}
