import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:study_hub/constants/colors.dart';
import 'package:study_hub/models/user_model.dart';
import 'package:study_hub/provider/authprovider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _departmentController = TextEditingController();
  final _semesterController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _departmentController.dispose();
    _semesterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = context.watch<UserModel?>();

    if (user != null && !_initialized) {
      _nameController.text = user.name;
      _departmentController.text = user.department;
      _semesterController.text = user.semester.toString();
      _initialized = true;
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: AppColors.background,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            'Profile',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
      body: user == null
          ? _buildSignedOutState(context)
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 56.r,
                          backgroundImage: user.profileImageUrl.isNotEmpty
                              ? NetworkImage(user.profileImageUrl)
                              : null,
                          backgroundColor: AppColors.primary.withOpacity(0.12),
                          child: user.profileImageUrl.isEmpty
                              ? Icon(
                                  Icons.person_outline,
                                  size: 48.sp,
                                  color: AppColors.primary,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: authProvider.isLoading
                                ? null
                                : () => authProvider.pickAndSetImage(
                                    uid: user.uid,
                                  ),
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  _buildTextField(
                    controller: _nameController,
                    label: 'Full Name',
                    icon: Icons.person_outline,
                  ),
                  SizedBox(height: 16.h),
                  _buildTextField(
                    controller: _departmentController,
                    label: 'Department',
                    icon: Icons.apartment_outlined,
                  ),
                  SizedBox(height: 16.h),
                  _buildTextField(
                    controller: _semesterController,
                    label: 'Semester',
                    icon: Icons.calendar_today_outlined,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    height: 54.h,
                    child: ElevatedButton(
                      onPressed: authProvider.isLoading
                          ? null
                          : () async {
                              final data = {
                                'name': _nameController.text.trim(),
                                'department': _departmentController.text.trim(),
                                'semester':
                                    int.tryParse(_semesterController.text) ?? 1,
                              };
                              await authProvider.updateProfile(
                                uid: user.uid,
                                data: data,
                              );
                              if (context.mounted &&
                                  authProvider.errorMessage == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Profile updated successfully!',
                                    ),
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: authProvider.isLoading
                          ? SizedBox(
                              width: 24.w,
                              height: 24.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    height: 54.h,
                    child: OutlinedButton(
                      onPressed: authProvider.isLoading
                          ? null
                          : () async {
                              await authProvider.signOut();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Signed out successfully.'),
                                  ),
                                );
                              }
                            },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary, width: 1.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  if (authProvider.errorMessage != null)
                    Padding(
                      padding: EdgeInsets.only(top: 16.h),
                      child: Text(
                        authProvider.errorMessage!,
                        style: TextStyle(
                          color: AppColors.danger,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14.r)),
      ),
    );
  }

  Widget _buildSignedOutState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off_outlined,
              size: 64.sp,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 16.h),
            Text(
              'You are not signed in',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Sign in to update your profile, manage study groups, and stay connected.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
