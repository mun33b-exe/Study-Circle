import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:study_circle/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_circle/provider/study_group_provider.dart';
import 'package:study_circle/models/study_group.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure the provider is listening to groups so we can filter locally
    final provider = context.read<StudyGroupProvider>();
    provider.listenAll();
  }

  @override
  Widget build(BuildContext context) {
    // We will get the user's name from FirebaseAuth or AuthProvider later
    final userName = FirebaseAuth.instance.currentUser?.displayName ?? 'You';
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Good day, $userName!",
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              "Here's your study schedule",
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(EvaIcons.bell, color: AppColors.textPrimary),
            onPressed: () {
              // Notification logic
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === SECTION 1: Quick Stats Card ===
            // (Inspired by the 'StudyBuddy' card)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Week at a Glance",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade900,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        // Dummy Stats (from dashboard requirements)
                        Text(
                          "• 3 Upcoming Sessions",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        Text(
                          "• 5 Active Groups",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    EvaIcons.pie_chart_2,
                    size: 60.sp,
                    color: Colors.green.shade700,
                  ),
                ],
              ),
            ),
            SizedBox(height: 25.h),

            // === SECTION 3: My Active Study Groups ===
            // Show groups where the current user is the creator or a member
            Text(
              "My Active Study Groups",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15.h),
            Consumer<StudyGroupProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.errorMessage != null) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Error loading your groups: ${provider.errorMessage}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                final List<StudyGroup> groups = provider.groups;
                final myGroups = (uid == null)
                    ? <StudyGroup>[]
                    : groups
                          .where(
                            (g) =>
                                g.creatorId == uid || g.members.contains(uid),
                          )
                          .toList();

                if (myGroups.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('You have no active study groups.'),
                  );
                }

                return ListView.builder(
                  itemCount: myGroups.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final g = myGroups[index];
                    return Card(
                      elevation: 0,
                      color: AppColors.cardBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: BorderSide(
                          color: AppColors.borderColor,
                          width: 1,
                        ),
                      ),
                      margin: EdgeInsets.only(bottom: 12.h),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            (g.name.isNotEmpty ? g.name.split(' ')[0] : 'G')
                                .substring(0, 2)
                                .toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                        title: Text(
                          g.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${g.courseName} • ${g.courseCode}',
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        trailing: Text(
                          '${g.members.length}/${g.maxMembers}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/groups/detail',
                          arguments: g,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
