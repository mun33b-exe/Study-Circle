import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:study_circle/constants/colors.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().baseColor,
      appBar: AppBar(backgroundColor: AppColors().baseColor),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Enter Your Details",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30.h),
                TextFormField(
                  cursorColor: Colors.black,
                  style: TextStyle(fontSize: 14.sp),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Enter your name",
                    labelText: "Name",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.r),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.r),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    enabled: true,
                  ),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  cursorColor: Colors.black,
                  style: TextStyle(fontSize: 14.sp),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    labelText: "Email",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.r),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.r),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    enabled: true,
                  ),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  cursorColor: Colors.black,
                  style: TextStyle(fontSize: 14.sp),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Enter your department",
                    labelText: "Department",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.r),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.r),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    enabled: true,
                  ),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  cursorColor: Colors.black,
                  style: TextStyle(fontSize: 14.sp),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Enter your semester",
                    labelText: "Semester",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.r),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.r),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    enabled: true,
                  ),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  obscureText: true,
                  cursorColor: Colors.black,
                  style: TextStyle(fontSize: 14.sp),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.remove_red_eye),
                    ),
                    hintText: "Enter Password",
                    labelText: "Password",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.r),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.r),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    enabled: true,
                  ),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  obscureText: true,
                  cursorColor: Colors.black,
                  style: TextStyle(fontSize: 14.sp),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.remove_red_eye),
                    ),
                    hintText: "Confirm Password",
                    labelText: "Confirm Password",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.r),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.r),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    enabled: true,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Already have account?",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.h),
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
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
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
      ),
    );
  }
}
