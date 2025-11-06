import 'package:flutter/foundation.dart';
import 'package:study_hub/models/study_group.dart';
import 'package:study_hub/services/study_group_service.dart';

class StudyGroupProvider extends ChangeNotifier {
  StudyGroupProvider(this._service);

  final StudyGroupService _service;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Stream<List<StudyGroup>> get allGroups => _service.getAllGroupsStream();

  Stream<List<StudyGroup>> getMyGroups(String uid) =>
      _service.getMyGroupsStream(uid);

  Stream<StudyGroup?> getGroupById(String groupId) =>
      _service.getGroupByIdStream(groupId);

  void _updateState({bool? loading, String? error}) {
    var shouldNotify = false;
    if (loading != null && _isLoading != loading) {
      _isLoading = loading;
      shouldNotify = true;
    }
    if (error != null || _errorMessage != error) {
      _errorMessage = error;
      shouldNotify = true;
    }
    if (shouldNotify) {
      notifyListeners();
    }
  }

  Future<String?> createGroup({
    required String groupName,
    required String courseName,
    required String courseCode,
    required String description,
    required int maxMembers,
    required bool isPrivate,
    required String createdByUid,
  }) async {
    _updateState(loading: true, error: null);
    try {
      final group = StudyGroup(
        id: '',
        groupName: groupName,
        courseName: courseName,
        courseCode: courseCode,
        description: description,
        maxMembers: maxMembers,
        isPrivate: isPrivate,
        createdByUid: createdByUid,
        members: <String>[createdByUid],
      );

      final groupId = await _service.createGroup(group);
      _updateState(loading: false, error: null);
      return groupId;
    } on StudyGroupException catch (e) {
      _updateState(loading: false, error: e.message);
    } catch (_) {
      _updateState(
        loading: false,
        error: 'Failed to create study group. Please try again.',
      );
    }
    return null;
  }

  Future<void> joinGroup({required String groupId, required String uid}) async {
    _updateState(loading: true, error: null);
    try {
      await _service.joinGroup(groupId, uid);
      _updateState(loading: false, error: null);
    } on StudyGroupException catch (e) {
      _updateState(loading: false, error: e.message);
    } catch (_) {
      _updateState(
        loading: false,
        error: 'Failed to join the study group. Please try again later.',
      );
    }
  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }
}
