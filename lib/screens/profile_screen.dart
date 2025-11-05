import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:study_circle/models/user_model.dart';
import 'package:study_circle/provider/authprovider.dart';

/// Profile Screen for editing user profile information
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _departmentController;
  late TextEditingController _semesterController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _departmentController = TextEditingController();
    _semesterController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _departmentController.dispose();
    _semesterController.dispose();
    super.dispose();
  }

  void _updateControllers(UserModel? user) {
    if (user != null) {
      _nameController.text = user.name;
      _departmentController.text = user.department;
      _semesterController.text = user.semester.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Consumer<UserModel?>(
        builder: (context, user, child) {
          // Update controllers when user data changes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updateControllers(user);
          });

          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Image Section
                      SizedBox(height: 20.h),
                      _buildProfileImage(user, authProvider),

                      SizedBox(height: 30.h),

                      // Name Field
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          prefixIcon: const Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 16.h),

                      // Department Field
                      TextFormField(
                        controller: _departmentController,
                        decoration: InputDecoration(
                          labelText: 'Department',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          prefixIcon: const Icon(Icons.school),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your department';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 16.h),

                      // Semester Field
                      TextFormField(
                        controller: _semesterController,
                        decoration: InputDecoration(
                          labelText: 'Semester',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          prefixIcon: const Icon(Icons.format_list_numbered),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your semester';
                          }
                          final semester = int.tryParse(value);
                          if (semester == null ||
                              semester < 1 ||
                              semester > 8) {
                            return 'Please enter a valid semester (1-8)';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 30.h),

                      // Update Profile Button
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: authProvider.isLoading
                              ? null
                              : () => _updateProfile(authProvider),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: authProvider.isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Update Profile',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Error Message
                      if (authProvider.errorMessage != null)
                        Container(
                          padding: EdgeInsets.all(12.w),
                          margin: EdgeInsets.only(bottom: 16.h),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red.shade600,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  authProvider.errorMessage!,
                                  style: TextStyle(color: Colors.red.shade600),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: OutlinedButton(
                          onPressed: () => _logout(authProvider),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: const Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProfileImage(UserModel user, AuthProvider authProvider) {
    return CircleAvatar(
      radius: 60.r,
      backgroundColor: Colors.grey.shade300,
      child: ClipOval(
        child: SizedBox(
          width: 120.r,
          height: 120.r,
          child: _buildImageWidget(user, authProvider),
        ),
      ),
    );
  }

  Widget _buildImageWidget(UserModel user, AuthProvider authProvider) {
    // Display network image if available, otherwise show default icon
    if (user.profileImageUrl.isNotEmpty) {
      return Image.network(
        user.profileImageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.person, size: 60.sp, color: Colors.grey.shade600);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    } else {
      return Icon(Icons.person, size: 60.sp, color: Colors.grey.shade600);
    }
  }

  void _updateProfile(AuthProvider authProvider) async {
    if (_formKey.currentState!.validate()) {
      authProvider.clearError();

      final name = _nameController.text.trim();
      final department = _departmentController.text.trim();
      final semester = int.parse(_semesterController.text.trim());

      await authProvider.updateProfile(name, department, semester);

      if (authProvider.errorMessage == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    }
  }

  void _logout(AuthProvider authProvider) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await authProvider.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }
}
