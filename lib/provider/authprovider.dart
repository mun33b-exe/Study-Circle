import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_hub/models/user_model.dart';
import 'package:study_hub/services/authservices.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._authService);

  final AuthService _authService;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Stream<UserModel?> get currentUserStream => _authService.currentUserStream;

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

  Future<void> signIn({required String email, required String password}) async {
    _updateState(loading: true, error: null);
    try {
      await _authService.signInWithEmail(email: email, password: password);
      _updateState(loading: false, error: null);
    } on FirebaseAuthException catch (e) {
      _updateState(loading: false, error: e.message ?? 'Failed to sign in.');
    } catch (_) {
      _updateState(
        loading: false,
        error: 'An unexpected error occurred while signing in.',
      );
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String department,
    required int semester,
  }) async {
    _updateState(loading: true, error: null);
    try {
      await _authService.signUpWithEmail(
        email: email,
        password: password,
        name: name,
        department: department,
        semester: semester,
      );
      _updateState(loading: false, error: null);
    } on FirebaseAuthException catch (e) {
      _updateState(loading: false, error: e.message ?? 'Failed to sign up.');
    } catch (_) {
      _updateState(
        loading: false,
        error: 'An unexpected error occurred while creating your account.',
      );
    }
  }

  Future<void> signOut() async {
    _updateState(loading: true, error: null);
    try {
      await _authService.signOut();
      _updateState(loading: false, error: null);
    } catch (_) {
      _updateState(loading: false, error: 'Failed to sign out.');
    }
  }

  Future<void> updateProfile({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    _updateState(loading: true, error: null);
    try {
      await _authService.updateUserProfile(uid: uid, data: data);
      _updateState(loading: false, error: null);
    } catch (_) {
      _updateState(
        loading: false,
        error: 'Failed to update profile. Please try again.',
      );
    }
  }

  Future<void> pickAndSetImage({
    required String uid,
    ImageSource source = ImageSource.gallery,
  }) async {
    _updateState(loading: true, error: null);
    try {
      final image = await _authService.pickImage(source: source);
      if (image == null) {
        _updateState(loading: false, error: null);
        return;
      }

      final downloadUrl = await _authService.uploadProfileImage(
        uid: uid,
        image: image,
      );

      await _authService.updateUserProfile(
        uid: uid,
        data: {'profileImageUrl': downloadUrl},
      );

      _updateState(loading: false, error: null);
    } catch (_) {
      _updateState(
        loading: false,
        error: 'Could not update profile image. Please try again.',
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
