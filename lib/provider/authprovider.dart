import 'package:flutter/material.dart';
import 'package:study_circle/services/authservices.dart';

/// AuthProvider manages authentication state and operations.
/// Extends ChangeNotifier for reactive state management with Provider.
class AuthProvider extends ChangeNotifier {
  final Authservices _authService;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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
}
