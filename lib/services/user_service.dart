import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseFirestore _db;
  UserService({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  Future<String> getDisplayName(String uid) async {
    try {
      // First try to get from Firestore users collection
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          // Check for displayName first, then name field
          if (data['displayName'] != null &&
              (data['displayName'] as String).isNotEmpty) {
            return data['displayName'] as String;
          }
          if (data['name'] != null && (data['name'] as String).isNotEmpty) {
            return data['name'] as String;
          }
        }
      }
    } catch (_) {}

    // If current user, try FirebaseAuth displayName
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.uid == uid) {
      if (currentUser.displayName != null &&
          currentUser.displayName!.isNotEmpty) {
        return currentUser.displayName!;
      }
      if (currentUser.email != null) {
        // Extract name from email (before @)
        return currentUser.email!.split('@')[0];
      }
    }

    // Last resort: return a formatted version of UID
    return 'User ${uid.substring(0, 8)}';
  }

  // Helper method to create/update user profile
  Future<void> createOrUpdateUserProfile(
    String uid, {
    String? displayName,
    String? email,
  }) async {
    try {
      final userRef = _db.collection('users').doc(uid);
      final userData = <String, dynamic>{};

      if (displayName != null && displayName.isNotEmpty) {
        userData['displayName'] = displayName;
      }
      if (email != null && email.isNotEmpty) {
        userData['email'] = email;
      }

      userData['lastUpdated'] = FieldValue.serverTimestamp();

      await userRef.set(userData, SetOptions(merge: true));
    } catch (e) {
      print('Error creating/updating user profile: $e');
    }
  }
}
