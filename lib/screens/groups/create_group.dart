import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:study_hub/constants/colors.dart';
import 'package:study_hub/models/user_model.dart';
import 'package:study_hub/provider/study_group_provider.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _groupNameController = TextEditingController();
  final _courseNameController = TextEditingController();
  final _courseCodeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _maxMembersController = TextEditingController(text: '10');
  bool _isPrivate = false;

  @override
  void dispose() {
    _groupNameController.dispose();
    _courseNameController.dispose();
    _courseCodeController.dispose();
    _descriptionController.dispose();
    _maxMembersController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate(BuildContext context) async {
    final studyGroupProvider = context.read<StudyGroupProvider>();
    final user = context.read<UserModel?>();

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to create a group.')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final maxMembers = int.tryParse(_maxMembersController.text.trim()) ?? 10;

    final groupId = await studyGroupProvider.createGroup(
      groupName: _groupNameController.text.trim(),
      courseName: _courseNameController.text.trim(),
      courseCode: _courseCodeController.text.trim(),
      description: _descriptionController.text.trim(),
      maxMembers: maxMembers,
      isPrivate: _isPrivate,
      createdByUid: user.uid,
    );

    if (mounted && groupId != null) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Study group created successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final studyGroupProvider = context.watch<StudyGroupProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Study Group'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bring your peers together',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Create a hub for collaborative learning with your classmates.',
                style: TextStyle(
                  fontSize: 15.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 24.h),
              _buildTextField(
                controller: _groupNameController,
                label: 'Group Name',
                icon: Icons.groups_2_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a group name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                controller: _courseNameController,
                label: 'Course Name',
                icon: Icons.book_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the course name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                controller: _courseCodeController,
                label: 'Course Code',
                icon: Icons.confirmation_number_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the course code';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                icon: Icons.description_outlined,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.length < 20) {
                    return 'Please provide at least 20 characters for the description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                controller: _maxMembersController,
                label: 'Maximum Members',
                icon: Icons.people_outline,
                keyboardType: TextInputType.number,
                validator: (value) {
                  final parsed = int.tryParse(value ?? '');
                  if (parsed == null || parsed < 2) {
                    return 'Enter a valid number greater than 1';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.05),
                      blurRadius: 12.r,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Private Group',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Restrict access to invited members only.',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isPrivate,
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() {
                          _isPrivate = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 28.h),
              SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: studyGroupProvider.isLoading
                      ? null
                      : () => _handleCreate(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: studyGroupProvider.isLoading
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
                          'Create Group',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14.r)),
      ),
      validator: validator,
    );
  }
}
