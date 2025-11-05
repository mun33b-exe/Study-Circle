// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_circle/constants/colors.dart';
import 'package:study_circle/provider/authprovider.dart'; // existing provider file

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    // Get provider instance (creates if parent provided it).
    final auth = Provider.of<AuthProvider>(context);

    // Use MediaQuery for sizing so this screen works in split-screen / multi-window modes
    final Size mq = MediaQuery.of(context).size;
    final double horizontalPadding = mq.width * 0.05;
    double buttonWidth = mq.width * 0.9;
    if (buttonWidth > 350.0) buttonWidth = 350.0;
    final double buttonHeight = 56.0;
    final double borderRadius = 40.0;

    return Scaffold(
      backgroundColor: AppColors().baseColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 12.0,
          ),
          child: Form(
            // Use provider controllers instead of local controllers
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 60.0),
                Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                // Email field (uses provider controller)
                TextFormField(
                  controller: auth.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: AppColors().whiteColor,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 12.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 12.0),
                // Password field (uses provider controller)
                TextFormField(
                  controller: auth.passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors().whiteColor,
                    suffixIcon: Icon(
                      Icons.visibility_off,
                      color: Colors.grey,
                      size: 20.0,
                    ),
                    hintText: 'Password',
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 12.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(onPressed: () {}, child: Text("Sign Up")),
                  ],
                ),
                SizedBox(height: 20.0),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: buttonHeight,
                    width: buttonWidth,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    child: TextButton(
                      onPressed: auth.isLoading
                          ? null
                          : () async {
                              // Clear previous error
                              auth.clearError();

                              // Attempt login via provider
                              final success = await auth.login();

                              if (!success) {
                                // Show provider error message (if any)
                                final msg = auth.errorMessage ?? 'Login failed';
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text(msg)));
                              } else {
                                // On success you can navigate to dashboard/home
                                // Navigator.pushReplacementNamed(context, '/dashboard');
                              }
                            },
                      child: auth.isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                // Show inline error if present
                if (auth.errorMessage != null) ...[
                  SizedBox(height: 12),
                  Text(
                    auth.errorMessage!,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
