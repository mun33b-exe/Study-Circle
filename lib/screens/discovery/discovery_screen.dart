import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:study_hub/constants/colors.dart';
import 'package:study_hub/models/study_group.dart';
import 'package:study_hub/provider/study_group_provider.dart';
import 'package:study_hub/screens/discovery/group_detail.dart';

class DiscoveryScreen extends StatelessWidget {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final studyGroupProvider = context.read<StudyGroupProvider>();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: AppColors.background,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            'Discover Groups',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<StudyGroup>>(
        stream: studyGroupProvider.allGroups,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final groups = snapshot.data ?? const <StudyGroup>[];

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(),
                SizedBox(height: 24.h),
                Text(
                  'Explore by Courses',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Join new study circles curated by your peers.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 16.h),
                if (groups.isEmpty)
                  _EmptyState(
                    title: 'No groups yet',
                    description:
                        'Check back later or start your own group to collaborate with classmates.',
                  )
                else
                  Column(
                    children: groups
                        .map(
                          (group) => _DiscoveryCard(
                            group: group,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      GroupDetailScreen(groupId: group.id),
                                ),
                              );
                            },
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Find your next study tribe',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Browse through curated study groups tailored by course, semester, and interests.',
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.white.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscoveryCard extends StatelessWidget {
  const _DiscoveryCard({required this.group, required this.onTap});

  final StudyGroup group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Icon(Icons.chevron_right, color: AppColors.textSecondary),
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
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
            SizedBox(height: 12.h),
            Text(
              group.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Icon(
                  Icons.people_alt_outlined,
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
                SizedBox(width: 16.w),
                Icon(
                  group.isPrivate ? Icons.lock_outline : Icons.public,
                  size: 16.sp,
                  color: group.isPrivate
                      ? AppColors.warning
                      : AppColors.success,
                ),
                SizedBox(width: 6.w),
                Text(
                  group.isPrivate ? 'Private' : 'Open',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: group.isPrivate
                        ? AppColors.warning
                        : AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
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
    return Container(
      padding: EdgeInsets.all(24.w),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            description,
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
