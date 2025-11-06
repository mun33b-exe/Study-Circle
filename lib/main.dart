import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:study_hub/firebase_options.dart';
import 'package:study_hub/constants/colors.dart';
import 'package:study_hub/models/user_model.dart';
import 'package:study_hub/provider/authprovider.dart';
import 'package:study_hub/provider/study_group_provider.dart';
import 'package:study_hub/screens/launcher.dart';
import 'package:study_hub/services/authservices.dart';
import 'package:study_hub/services/study_group_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authService = AuthService();
  final studyGroupService = StudyGroupService();

  runApp(
    StudyCircleApp(
      authService: authService,
      studyGroupService: studyGroupService,
    ),
  );
}

class StudyCircleApp extends StatelessWidget {
  const StudyCircleApp({
    super.key,
    required this.authService,
    required this.studyGroupService,
  });

  final AuthService authService;
  final StudyGroupService studyGroupService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>.value(value: authService),
        Provider<StudyGroupService>.value(value: studyGroupService),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(authService),
        ),
        ChangeNotifierProvider<StudyGroupProvider>(
          create: (_) => StudyGroupProvider(studyGroupService),
        ),
        StreamProvider<UserModel?>.value(
          value: authService.currentUserStream,
          initialData: null,
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) => MaterialApp(
          title: 'StudyCircle',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Outfit',
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            scaffoldBackgroundColor: AppColors.background,
            useMaterial3: true,
          ),
          home: const LauncherScreen(),
        ),
      ),
    );
  }
}
