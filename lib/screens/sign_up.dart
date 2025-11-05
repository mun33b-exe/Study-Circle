// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:study_circle/constants/colors.dart';
import 'package:study_circle/provider/authprovider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late TextEditingController departmentController;
  late TextEditingController semesterController;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    departmentController = TextEditingController();
    semesterController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    departmentController.dispose();
    semesterController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your name';
    if (value.length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) return 'Please enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != passwordController.text) return 'Passwords do not match';
    return null;
  }

  String? _validateDepartment(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your department';
    return null;
  }

  String? _validateSemester(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your semester';
    final semester = int.tryParse(value);
    if (semester == null || semester < 1 || semester > 8) {
      return 'Please enter a valid semester (1-8)';
    }
    return null;
  }

  InputDecoration _buildInputDecoration(
    String label,
    String hint, {
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      labelText: label,
      labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      suffixIcon: suffixIcon,
      border: InputBorder.none,
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7.r),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7.r),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7.r),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7.r),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      filled: true,
      fillColor: Colors.white,
      enabled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.baseColor,
      appBar: AppBar(backgroundColor: AppColors.baseColor),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Enter Your Details",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  TextFormField(
                    controller: nameController,
                    validator: _validateName,
                    cursorColor: Colors.black,
                    style: TextStyle(fontSize: 14.sp),
                    keyboardType: TextInputType.text,
                    decoration: _buildInputDecoration(
                      "Name",
                      "Enter your name",
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    controller: emailController,
                    validator: _validateEmail,
                    cursorColor: Colors.black,
                    style: TextStyle(fontSize: 14.sp),
                    keyboardType: TextInputType.emailAddress,
                    decoration: _buildInputDecoration(
                      "Email",
                      "Enter your email",
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    controller: departmentController,
                    validator: _validateDepartment,
                    cursorColor: Colors.black,
                    style: TextStyle(fontSize: 14.sp),
                    keyboardType: TextInputType.text,
                    decoration: _buildInputDecoration(
                      "Department",
                      "Enter your department",
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    controller: semesterController,
                    validator: _validateSemester,
                    cursorColor: Colors.black,
                    style: TextStyle(fontSize: 14.sp),
                    keyboardType: TextInputType.number,
                    decoration: _buildInputDecoration(
                      "Semester",
                      "Enter your semester",
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    controller: passwordController,
                    validator: _validatePassword,
                    obscureText: _obscurePassword,
                    cursorColor: Colors.black,
                    style: TextStyle(fontSize: 14.sp),
                    keyboardType: TextInputType.text,
                    decoration: _buildInputDecoration(
                      "Password",
                      "Enter Password",
                      suffixIcon: IconButton(
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    controller: confirmPasswordController,
                    validator: _validateConfirmPassword,
                    obscureText: _obscureConfirmPassword,
                    cursorColor: Colors.black,
                    style: TextStyle(fontSize: 14.sp),
                    keyboardType: TextInputType.text,
                    decoration: _buildInputDecoration(
                      "Confirm Password",
                      "Confirm Password",
                      suffixIcon: IconButton(
                        onPressed: () => setState(
                          () => _obscureConfirmPassword =
                              !_obscureConfirmPassword,
                        ),
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Already have account?",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, _) {
                      return Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 56.h,
                          width: 350.w,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(40.r),
                          ),
                          child: authProvider.isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.baseColor,
                                    ),
                                  ),
                                )
                              : TextButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      final semester = int.parse(
                                        semesterController.text,
                                      );
                                      final success = await authProvider.signUp(
                                        emailController.text.trim(),
                                        passwordController.text,
                                        nameController.text.trim(),
                                        departmentController.text.trim(),
                                        semester,
                                      );

                                      if (success) {
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Sign up successful!',
                                            ),
                                            backgroundColor: Colors.green,
                                            duration: Duration(
                                              milliseconds: 1500,
                                            ),
                                          ),
                                        );

                                        // Small delay to ensure auth state is updated
                                        await Future.delayed(
                                          const Duration(milliseconds: 500),
                                        );

                                        if (mounted) {
                                          // Navigate to main screen after successful signup
                                          Navigator.of(
                                            context,
                                          ).pushNamedAndRemoveUntil(
                                            '/',
                                            (route) => false,
                                          );
                                        }
                                      } else {
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              authProvider.errorMessage ??
                                                  'Sign up failed',
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: Text(
                                    "Sign Up",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
