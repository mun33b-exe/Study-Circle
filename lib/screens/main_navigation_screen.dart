import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:study_hub/constants/colors.dart';
import 'package:study_hub/screens/dashboard/dashboard_screen.dart';
import 'package:study_hub/screens/discovery/discovery_screen.dart';
import 'package:study_hub/screens/groups/my_groups_screen.dart';
import 'package:study_hub/screens/profile/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    DiscoveryScreen(),
    MyGroupsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12.r,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          selectedFontSize: 12.sp,
          unselectedFontSize: 12.sp,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(LineAwesome.home_solid),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(LineAwesome.compass_solid),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Icon(LineAwesome.user_friends_solid),
              label: 'My Groups',
            ),
            BottomNavigationBarItem(
              icon: Icon(LineAwesome.user_circle_solid),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
