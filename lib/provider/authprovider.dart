import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_circle/models/user_model.dart';
import 'package:study_circle/services/authservices.dart';

/// AuthProvider manages authentication state and operations.
/// Extends ChangeNotifier for reactive state management with Provider.
class AuthProvider extends ChangeNotifier {
  final Authservices _authService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Stream of current user data from Firestore
  Stream<UserModel?> get currentUserStream {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value(null);
    }

    return _firestore.collection('users').doc(user.uid).snapshots().map((
      snapshot,
    ) {
      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data()!, snapshot.id);
      }
      return null;
    });
  }

  AuthProvider(this._authService);

  /// Sets loading state and notifies listeners.
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Sets error message and notifies listeners.
  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// Clears any existing error message and notifies listeners.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Sign in with email and password.
  /// Returns true on success, false on failure.
  /// Error message is available via [errorMessage].
  Future<bool> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _setError('Please enter both email and password.');
      return false;
    }

    _setLoading(true);
    _setError(null);

    try {
      await _authService.signInWithEmail(email, password);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Sign up with email, password, and profile information.
  /// Returns true on success, false on failure.
  /// Error message is available via [errorMessage].
  Future<bool> signUp(
    String email,
    String password,
    String name,
    String department,
    int semester,
  ) async {
    if (email.isEmpty ||
        password.isEmpty ||
        name.isEmpty ||
        department.isEmpty) {
      _setError('Please fill in all required fields.');
      return false;
    }

    _setLoading(true);
    _setError(null);

    try {
      await _authService.signUpWithEmail(
        email,
        password,
        name,
        department,
        semester,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Sign in with Google.
  /// Returns true on success, false on failure.
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _setError(null);

    try {
      await _authService.signInWithGoogle();
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    _setLoading(true);
    _setError(null);

    try {
      await _authService.signOut();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Update user profile information
  Future<void> updateProfile(
    String name,
    String department,
    int semester,
  ) async {
    _setLoading(true);
    _setError(null);

    try {
      final uid = _auth.currentUser!.uid;

      // Update profile in Firestore (without image for now)
      await _authService.updateUserProfile(
        uid,
        name: name,
        department: department,
        semester: semester,
      );

      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }
}
