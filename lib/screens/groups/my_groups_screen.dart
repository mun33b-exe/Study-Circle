import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:study_hub/constants/colors.dart';
import 'package:study_hub/models/study_group.dart';
import 'package:study_hub/models/user_model.dart';
import 'package:study_hub/provider/study_group_provider.dart';
import 'package:study_hub/screens/groups/create_group.dart';

class MyGroupsScreen extends StatelessWidget {
  const MyGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserModel?>();
    final studyGroupProvider = context.read<StudyGroupProvider>();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: AppColors.background,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            'My Groups',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const CreateGroupScreen()));
        },
        icon: const Icon(LineAwesome.plus_solid),
        label: const Text('New Group'),
      ),
      body: user == null
          ? _EmptyState(
              title: 'Sign in required',
              description:
                  'Please sign in to manage your study groups and stay connected.',
            )
          : StreamBuilder<List<StudyGroup>>(
              stream: studyGroupProvider.getMyGroups(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final groups = snapshot.data ?? const <StudyGroup>[];

                if (groups.isEmpty) {
                  return _EmptyState(
                    title: 'No study groups yet',
                    description:
                        'Join or create a study group to start collaborating with peers.',
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 16.h,
                  ),
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    final group = groups[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 16.h),
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
                                group.isPrivate
                                    ? Icons.lock_outline
                                    : Icons.public,
                                color: group.isPrivate
                                    ? AppColors.warning
                                    : AppColors.success,
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            group.groupName,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            group.courseName,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Icon(
                                Icons.people_outline,
                                size: 18.sp,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                '${group.members.length}/${group.maxMembers} members',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group_off_outlined,
              size: 64.sp,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
