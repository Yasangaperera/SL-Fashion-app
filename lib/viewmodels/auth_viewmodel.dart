import 'package:flutter/foundation.dart';

class AuthViewModel extends ChangeNotifier {

  //State
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters — Views read these
  bool   get isLoading     => _isLoading;
  String get errorMessage  => _errorMessage;

  // Login Logic
  Future<bool> login(String email, String password) async {
    _errorMessage = '';

    if (email.trim().isEmpty || password.isEmpty) {
      _errorMessage = 'Please enter your email and password';

      notifyListeners();
      return false;
    }
    if (!email.contains('@')) {
      _errorMessage = 'Please enter a valid email address';

      notifyListeners();
      return false;
    }
    if (password.length < 6) {
      _errorMessage = 'Password must be at least 6 characters';

      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1)); // fake loading

    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Register Logic
  Future<bool> register(
      String name, String email, String password, String confirmPassword) async {
    _errorMessage = '';

    if (name.trim().isEmpty || email.trim().isEmpty ||
        password.isEmpty || confirmPassword.isEmpty) {
      _errorMessage = 'PLease fill in all fields';

      notifyListeners();
      return false;
    }
    if (!email.contains('@')) {
      _errorMessage = 'Please add valid E-mail address';
      notifyListeners();
      return false;
    }
    if (password.length < 6) {
      _errorMessage = 'Password must be at least 6 characters';
      notifyListeners();
      return false;
    }
    if (password != confirmPassword) {
      _errorMessage = 'Password do not match!';

      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Clear error when user starts typing again
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
