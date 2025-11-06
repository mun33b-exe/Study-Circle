import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:study_hub/constants/colors.dart';
import 'package:study_hub/models/study_group.dart';
import 'package:study_hub/models/user_model.dart';
import 'package:study_hub/provider/study_group_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserModel?>();
    final studyGroupProvider = context.read<StudyGroupProvider>();

    final greetingName = user?.name.split(' ').first ?? 'there';
    final myGroupsStream = user != null
        ? studyGroupProvider.getMyGroups(user.uid)
        : null;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: AppColors.background,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            'StudyCircle',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreetingCard(greetingName),
            SizedBox(height: 24.h),
            _buildSectionHeader(
              title: 'My Active Study Groups',
              subtitle: 'Stay in sync with your peers',
            ),
            SizedBox(height: 12.h),
            if (myGroupsStream == null)
              _EmptyStateCard(
                title: 'Create your profile to get started',
                description:
                    'Complete your sign up to start exploring study groups.',
              )
            else
              StreamBuilder<List<StudyGroup>>(
                stream: myGroupsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final groups = snapshot.data ?? const <StudyGroup>[];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${groups.length} Active Groups',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      if (groups.isEmpty)
                        _EmptyStateCard(
                          title: 'No active groups yet',
                          description:
                              'Join a study group from the discovery tab or create your own.',
                        )
                      else
                        Column(
                          children: groups
                              .map((group) => _GroupListTile(group: group))
                              .toList(),
                        ),
                    ],
                  );
                },
              ),
            SizedBox(height: 32.h),
            _buildSectionHeader(
              title: 'Upcoming Sessions',
              subtitle: "Don't miss your next meetup",
            ),
            SizedBox(height: 12.h),
            _buildUpcomingSessions(),
          ],
        ),
      ),
    );
  }

  Widget _buildGreetingCard(String name) {
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
            'Good day, $name!',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Keep up the momentum. Explore your groups and upcoming sessions.',
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.white.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          subtitle,
          style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildUpcomingSessions() {
    final sessions = [
      _UpcomingSession(
        title: 'Calculus II Review',
        topic: 'Integration techniques',
        date: 'Wednesday, 4:00 PM',
      ),
      _UpcomingSession(
        title: 'Data Structures Deep Dive',
        topic: 'Binary Trees & Graphs',
        date: 'Friday, 2:30 PM',
      ),
    ];

    return Column(
      children: sessions
          .map(
            (session) => Container(
              margin: EdgeInsets.only(bottom: 12.h),
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
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Icon(Icons.event_note, color: AppColors.primary),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.title,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          session.topic,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          session.date,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _GroupListTile extends StatelessWidget {
  const _GroupListTile({required this.group});

  final StudyGroup group;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(Icons.people_rounded, color: AppColors.primary),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.groupName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${group.courseName} • ${group.courseCode}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  '${group.members.length}/${group.maxMembers} members',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
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

class _UpcomingSession {
  const _UpcomingSession({
    required this.title,
    required this.topic,
    required this.date,
  });

  final String title;
  final String topic;
  final String date;
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard({required this.title, required this.description});

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
