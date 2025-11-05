import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:study_circle/constants/colors.dart';

class Launcher extends StatelessWidget {
  const Launcher({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch the auth state from StreamProvider
    final user = context.watch<User?>();

    // If user is authenticated, navigate to dashboard/home
    // For now, we'll show a simple home screen
    if (user != null) {
      return HomeScreen(user: user);
    }

    // If user is not authenticated, show the launcher screen
    return const _LauncherScreen();
  }
}

class _LauncherScreen extends StatefulWidget {
  const _LauncherScreen();

  @override
  State<_LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<_LauncherScreen> {
  final String image = "assets/images/launcher.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().baseColor,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(alignment: Alignment.topRight, child: Image.asset(image)),
              SizedBox(height: 40.h),
              SizedBox(
                height: 100.h,
                width: 250.w,
                child: Padding(
                  padding: EdgeInsets.only(left: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome to", style: TextStyle(fontSize: 16.sp)),
                      Text(
                        "Study Circle",
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50.h),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 56.h,
                  width: 350.w,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: Text(
                      "Create an account",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 56.h,
                  width: 350.w,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
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
}

// Simple home screen placeholder for authenticated users
class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors().baseColor,
        title: const Text('Dashboard'),
      ),
      backgroundColor: AppColors().baseColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${user.email}!',
              style: TextStyle(fontSize: 18.sp),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () async {
                // Sign out
                // Use context to access AuthProvider and call signOut
                // This will update the StreamProvider and navigate back to launcher
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
