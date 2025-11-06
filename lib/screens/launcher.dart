import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_hub/models/user_model.dart';
import 'package:study_hub/screens/auth/login_ui.dart';
import 'package:study_hub/screens/main_navigation_screen.dart';

class LauncherScreen extends StatelessWidget {
  const LauncherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserModel?>();

    if (user == null) {
      return const LoginScreen();
    }

    return const MainNavigationScreen();
  }
}
