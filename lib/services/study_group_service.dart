import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_hub/models/study_group.dart';

class StudyGroupException implements Exception {
  const StudyGroupException(this.message);

  final String message;

  @override
  String toString() => message;
}

class StudyGroupService {
  StudyGroupService() : _firestore = FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _groupsRef =>
      _firestore.collection('groups');

  Future<String> createGroup(StudyGroup group) async {
    final docRef = await _groupsRef.add(group.toMap());
    return docRef.id;
  }

  Stream<List<StudyGroup>> getAllGroupsStream() {
    return _groupsRef.snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => StudyGroup.fromFirestore(doc)).toList(),
    );
  }

  Stream<List<StudyGroup>> getMyGroupsStream(String uid) {
    return _groupsRef
        .where('members', arrayContains: uid)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => StudyGroup.fromFirestore(doc))
              .toList(),
        );
  }

  Stream<StudyGroup?> getGroupByIdStream(String groupId) {
    return _groupsRef.doc(groupId).snapshots().map((doc) {
      if (!doc.exists) {
        return null;
      }
      return StudyGroup.fromFirestore(doc);
    });
  }

  Future<void> joinGroup(String groupId, String uid) async {
    final docRef = _groupsRef.doc(groupId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        throw const StudyGroupException('Study group not found.');
      }

      final group = StudyGroup.fromFirestore(snapshot);
      if (group.members.contains(uid)) {
        throw const StudyGroupException(
          'You are already a member of this group.',
        );
      }

      if (group.isPrivate) {
        throw const StudyGroupException(
          'This is a private group. Request access from the admin.',
        );
      }

      if (group.members.length >= group.maxMembers) {
        throw const StudyGroupException(
          'This group has reached its member limit.',
        );
      }

      transaction.update(docRef, {
        'members': FieldValue.arrayUnion([uid]),
      });
    });
  }
}
