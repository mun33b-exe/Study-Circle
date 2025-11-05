// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:study_circle/constants/colors.dart';
import 'package:study_circle/provider/authprovider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) return 'Please enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Size mq = MediaQuery.of(context).size;
    final double horizontalPadding = mq.width * 0.05;
    double buttonWidth = mq.width * 0.9;
    if (buttonWidth > 350.0) buttonWidth = 350.0;
    final double buttonHeight = 56.0;
    final double borderRadius = 40.0;

    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors().baseColor),
      backgroundColor: AppColors().baseColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 12.0,
          ),
          child: Form(
            key: _formKey,
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
                // Email field
                TextFormField(
                  controller: emailController,
                  validator: _validateEmail,
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
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.red, width: 1),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.red, width: 1),
                    ),
                  ),
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 12.0),
                // Password field
                TextFormField(
                  controller: passwordController,
                  validator: _validatePassword,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors().whiteColor,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                        size: 20.0,
                      ),
                    ),
                    hintText: 'Password',
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 12.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.red, width: 1),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.red, width: 1),
                    ),
                  ),
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text("Sign Up"),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: buttonHeight,
                        width: buttonWidth,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        child: authProvider.isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors().baseColor,
                                  ),
                                ),
                              )
                            : TextButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    final success = await authProvider.signIn(
                                      emailController.text.trim(),
                                      passwordController.text,
                                    );

                                    if (!success && mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            authProvider.errorMessage ?? 'Login failed',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20.0),
                // Google Sign-In Button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return Align(
                      alignment: Alignment.center,
                      child: SignInButton(
                        Buttons.google,
                        onPressed: () async {
                          final success = await authProvider.signInWithGoogle();
                          if (!success && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  authProvider.errorMessage ?? 'Google sign-in failed',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
