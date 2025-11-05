import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _db;
  UserService({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  Future<String?> getDisplayName(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null &&
            data['displayName'] != null &&
            (data['displayName'] as String).isNotEmpty) {
          return data['displayName'] as String;
        }
      }
    } catch (_) {}
    // fallback to FirebaseAuth displayName if available
    final user = FirebaseAuth.instance.currentUser;
    if (user != null &&
        user.uid == uid &&
        user.displayName != null &&
        user.displayName!.isNotEmpty)
      return user.displayName;
    return null;
  }
}
