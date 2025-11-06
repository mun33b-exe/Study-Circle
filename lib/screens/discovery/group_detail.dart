import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:study_hub/constants/colors.dart';
import 'package:study_hub/models/study_group.dart';
import 'package:study_hub/models/user_model.dart';
import 'package:study_hub/provider/study_group_provider.dart';

class GroupDetailScreen extends StatelessWidget {
  const GroupDetailScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserModel?>();
    final studyGroupProvider = context.read<StudyGroupProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Details'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
      ),
      body: StreamBuilder<StudyGroup?>(
        stream: studyGroupProvider.getGroupById(groupId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final group = snapshot.data;
          if (group == null) {
            return Center(
              child: Text(
                'Group not found.',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            );
          }

          final isMember = user != null && group.members.contains(user.uid);
          final isFull = group.members.length >= group.maxMembers;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.05),
                        blurRadius: 12.r,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Text(
                              group.courseCode,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            group.isPrivate ? Icons.lock_outline : Icons.public,
                            color: group.isPrivate
                                ? AppColors.warning
                                : AppColors.success,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            group.isPrivate ? 'Private Group' : 'Open Group',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: group.isPrivate
                                  ? AppColors.warning
                                  : AppColors.success,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        group.groupName,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        group.courseName,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Text(
                        group.description,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textPrimary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                _InfoTile(
                  icon: Icons.people_outline,
                  title: 'Members',
                  value:
                      '${group.members.length} of ${group.maxMembers} seats filled',
                ),
                SizedBox(height: 12.h),
                _InfoTile(
                  icon: Icons.account_circle_outlined,
                  title: 'Created By',
                  value: group.createdByUid,
                ),
                SizedBox(height: 12.h),
                _InfoTile(
                  icon: Icons.lock_outline,
                  title: 'Visibility',
                  value: group.isPrivate ? 'Private' : 'Open to join',
                ),
                SizedBox(height: 32.h),
                SizedBox(
                  width: double.infinity,
                  height: 54.h,
                  child: ElevatedButton(
                    onPressed:
                        (user == null || isMember || isFull || group.isPrivate)
                        ? null
                        : () async {
                            try {
                              await studyGroupProvider.joinGroup(
                                groupId: group.id,
                                uid: user!.uid,
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Successfully joined the group!',
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text('$e')));
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.textSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Text(
                      _buildButtonLabel(
                        isMember: isMember,
                        isFull: isFull,
                        isPrivate: group.isPrivate,
                        isAuthenticated: user != null,
                      ),
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
          );
        },
      ),
    );
  }

  String _buildButtonLabel({
    required bool isMember,
    required bool isFull,
    required bool isPrivate,
    required bool isAuthenticated,
  }) {
    if (!isAuthenticated) {
      return 'Sign in to join';
    }
    if (isMember) {
      return 'Already a member';
    }
    if (isFull) {
      return 'Group is full';
    }
    if (isPrivate) {
      return 'Private group';
    }
    return 'Join Group';
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
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
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
