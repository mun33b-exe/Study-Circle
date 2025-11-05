import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:study_circle/constants/colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We will get the user's name from AuthProvider later
    String userName = "Muneeb"; // Use dummy data for now

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

            // === SECTION 2: Upcoming Study Sessions ===
            // (Inspired by 'Popular videos' horizontal list)
            Text(
              "My Upcoming Study Sessions",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15.h),
            SizedBox(
              height: 180.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3, // Dummy data
                itemBuilder: (context, index) {
                  return Container(
                    width: 150.w,
                    margin: EdgeInsets.only(right: 15.w),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Session Title",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "CS101 - Algorithms",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "Nov ${5 + index}, 3:00 PM",
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 25.h),

            // === SECTION 3: My Active Study Groups ===
            // (Inspired by 'Popular Jobs' vertical list)
            Text(
              "My Active Study Groups",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15.h),
            ListView.builder(
              itemCount: 2, // Dummy data
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final groupNames = ["CS101 Final Review", "Biology Lab Group"];
                final departments = ["Computer Science", "Biology"];
                final memberCounts = ["5/10", "7/8"];

                return Card(
                  elevation: 0,
                  color: AppColors.cardBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide(color: AppColors.borderColor, width: 1),
                  ),
                  margin: EdgeInsets.only(bottom: 12.h),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        groupNames[index].split(' ')[0].substring(0, 2),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                    title: Text(
                      groupNames[index],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      departments[index],
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    trailing: Text(
                      memberCounts[index],
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
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
