import 'dart:async';

import 'package:flutter/material.dart';
import 'package:study_circle/models/study_group.dart';
import 'package:study_circle/models/join_request.dart';
import 'package:study_circle/services/study_group_service.dart';

class StudyGroupProvider extends ChangeNotifier {
  final StudyGroupService _service;

  bool isLoading = false;
  String? errorMessage;

  List<StudyGroup> groups = [];
  StreamSubscription<List<StudyGroup>>? _sub;

  StudyGroupProvider(this._service);

  void listenAll() {
    _sub?.cancel();
    _sub = _service.streamAllGroups().listen(
      (data) {
        groups = data;
        notifyListeners();
      },
      onError: (e) {
        errorMessage = e.toString();
        notifyListeners();
      },
    );
  }

  void listenByCreator(String creatorId) {
    _sub?.cancel();
    _sub = _service
        .streamGroupsByCreator(creatorId)
        .listen(
          (data) {
            groups = data;
            notifyListeners();
          },
          onError: (e) {
            errorMessage = e.toString();
            notifyListeners();
          },
        );
  }

  Future<bool> createGroup(StudyGroup group) async {
    try {
      isLoading = true;
      notifyListeners();
      final id = await _service.createGroup(group);
      isLoading = false;
      notifyListeners();
      return id.isNotEmpty;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateGroup(StudyGroup group) async {
    try {
      isLoading = true;
      notifyListeners();
      await _service.updateGroup(group);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteGroup(String id) async {
    try {
      isLoading = true;
      notifyListeners();
      await _service.deleteGroup(id);
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> joinGroup(String groupId, String userId) async {
    try {
      await _service.joinGroup(groupId, userId);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> leaveGroup(String groupId, String userId) async {
    try {
      await _service.leaveGroup(groupId, userId);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Join request workflow
  Future<void> requestJoin(
    String groupId,
    String userId, {
    String? displayName,
  }) async {
    try {
      await _service.requestJoin(groupId, userId, displayName: displayName);
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Stream<List<JoinRequest>> streamJoinRequests(String groupId) {
    return _service
        .streamJoinRequests(groupId)
        .map((list) => list.map((m) => JoinRequest.fromMap(m)).toList());
  }

  Future<void> approveRequest(
    String groupId,
    String requestId,
    String userId,
  ) async {
    try {
      await _service.approveRequest(groupId, requestId, userId);
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> rejectRequest(String groupId, String requestId) async {
    try {
      await _service.rejectRequest(groupId, requestId);
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
