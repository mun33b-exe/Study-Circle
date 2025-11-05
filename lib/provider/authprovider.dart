import 'package:flutter/material.dart';
import 'package:study_circle/services/authservices.dart';

/// Provider for authentication-related UI/state used by login/register screens.
/// - Holds TextEditingControllers to keep controller lifecycle in one place.
/// - Exposes loading and error state for UI to react to.
/// - Provides a `login` helper that wraps the Authservices login call.
class AuthProvider extends ChangeNotifier {
  // Controllers owned by the provider so screens don't need to recreate/dispose them.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Sets loading state and notifies listeners.
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Clears any existing error message and notifies listeners.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Attempts to log the user in using Authservices.
  /// Returns true on success, false on failure. Error message is available via [errorMessage].
  Future<bool> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Basic validation
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Please enter both email and password.';
      notifyListeners();
      return false;
    }

    _setLoading(true);
    try {
      // Delegates actual Firebase auth to Authservices.
      await Authservices().login(email, password);
      _errorMessage = null;
      return true;
    } catch (e) {
      // Capture error for UI; keep message concise.
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Dispose controllers when provider is removed.
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
