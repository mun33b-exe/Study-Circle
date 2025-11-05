import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_circle/models/study_group.dart';

class StudyGroupService {
  final FirebaseFirestore _db;
  final String collection = 'study_groups';

  StudyGroupService({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  Future<String> createGroup(StudyGroup group) async {
    final doc = await _db.collection(collection).add(group.toMap());
    return doc.id;
  }

  Future<void> updateGroup(StudyGroup group) async {
    await _db.collection(collection).doc(group.id).update(group.toMap());
  }

  Future<void> deleteGroup(String id) async {
    await _db.collection(collection).doc(id).delete();
  }

  Stream<List<StudyGroup>> streamAllGroups() {
    return _db
        .collection(collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (QuerySnapshot<Map<String, dynamic>> snap) =>
              snap.docs.map((d) => StudyGroup.fromDoc(d)).toList(),
        );
  }

  Stream<List<StudyGroup>> streamGroupsByCreator(String creatorId) {
    return _db
        .collection(collection)
        .where('creatorId', isEqualTo: creatorId)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snap) {
          final groups = snap.docs.map((d) => StudyGroup.fromDoc(d)).toList();
          // Sort in-app to avoid needing a Firestore composite index
          groups.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return groups;
        });
  }

  Future<StudyGroup?> getGroupById(String id) async {
    final doc = await _db.collection(collection).doc(id).get();
    if (!doc.exists) return null;
    return StudyGroup.fromDoc(doc);
  }

  Future<void> joinGroup(String groupId, String userId) async {
    final ref = _db.collection(collection).doc(groupId);
    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final data = snap.data();
      final members = List<String>.from(data?['members'] ?? []);
      if (!members.contains(userId)) members.add(userId);
      tx.update(ref, {'members': members});
    });
  }

  Future<void> leaveGroup(String groupId, String userId) async {
    final ref = _db.collection(collection).doc(groupId);
    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final data = snap.data();
      final members = List<String>.from(data?['members'] ?? []);
      members.removeWhere((m) => m == userId);
      tx.update(ref, {'members': members});
    });
  }

  // Join request workflow for private groups
  Future<void> requestJoin(
    String groupId,
    String userId, {
    String? displayName,
  }) async {
    final ref = _db
        .collection(collection)
        .doc(groupId)
        .collection('join_requests');
    await ref.add({
      'userId': userId,
      'displayName': displayName ?? '',
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> streamJoinRequests(String groupId) {
    final ref = _db
        .collection(collection)
        .doc(groupId)
        .collection('join_requests');
    return ref
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (QuerySnapshot<Map<String, dynamic>> snap) => snap.docs
              .map(
                (d) => {
                  'id': d.id,
                  'userId': d.data()['userId'],
                  'displayName': d.data()['displayName'],
                  'status': d.data()['status'],
                },
              )
              .toList(),
        );
  }

  Future<void> approveRequest(
    String groupId,
    String requestId,
    String userId,
  ) async {
    final reqRef = _db
        .collection(collection)
        .doc(groupId)
        .collection('join_requests')
        .doc(requestId);
    final groupRef = _db.collection(collection).doc(groupId);
    await _db.runTransaction((tx) async {
      final gsnap = await tx.get(groupRef);
      final gdata = gsnap.data();
      final members = List<String>.from(gdata?['members'] ?? []);
      if (!members.contains(userId)) members.add(userId);
      tx.update(groupRef, {'members': members});
      tx.delete(reqRef);
    });
  }

  Future<void> rejectRequest(String groupId, String requestId) async {
    final reqRef = _db
        .collection(collection)
        .doc(groupId)
        .collection('join_requests')
        .doc(requestId);
    await reqRef.delete();
  }

  /// Get a LIVE stream of ALL groups for the Discovery screen
  Stream<List<StudyGroup>> getAllGroupsStream() {
    return _db.collection(collection).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => StudyGroup.fromDoc(doc))
          .toList();
    });
  }

  /// Get a LIVE stream of a SINGLE group for the details page
  Stream<StudyGroup> getGroupByIdStream(String groupId) {
    return _db
        .collection(collection)
        .doc(groupId)
        .snapshots()
        .map((doc) => StudyGroup.fromDoc(doc));
  }

  /// Enhanced join group method with business logic
  Future<String> joinGroupWithValidation(String groupId, String uid) async {
    final docRef = _db.collection(collection).doc(groupId);
    
    return _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw Exception("Group does not exist!");
      }

      final group = StudyGroup.fromDoc(snapshot);

      // Business Logic Checks
      if (group.members.contains(uid)) {
        return "You are already a member of this group.";
      }
      if (group.members.length >= group.maxMembers) {
        return "This group is already full.";
      }
      if (!group.isPublic) {
        // Private group logic - deny for now
        return "This is a private group. Please request an invite.";
      }

      // All checks passed. Add the user.
      transaction.update(docRef, {
        'members': FieldValue.arrayUnion([uid])
      });
      return "Successfully joined ${group.name}!";
    });
  }
}
