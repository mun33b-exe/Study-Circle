import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_circle/firebase_options.dart';
import 'package:study_circle/screens/launcher.dart';
import 'package:study_circle/screens/sign_up.dart';
import 'package:study_circle/screens/login_ui.dart';
import 'package:study_circle/screens/create_group.dart';
import 'package:study_circle/screens/group_detail.dart';
import 'package:study_circle/screens/my_groups_screen.dart';
import 'package:study_circle/provider/study_group_provider.dart';
import 'package:study_circle/services/study_group_service.dart';
import 'package:provider/provider.dart';
import 'package:study_circle/provider/authprovider.dart';
import 'package:study_circle/services/authservices.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      builder: (context, child) => child!,
      child: MultiProvider(
        providers: [
          // Firebase Auth Service provider
          Provider<Authservices>(create: (_) => Authservices()),
          // StudyGroup service provider
          Provider<StudyGroupService>(create: (_) => StudyGroupService()),
          // StudyGroup provider
          ChangeNotifierProvider<StudyGroupProvider>(
            create: (context) =>
                StudyGroupProvider(context.read<StudyGroupService>()),
          ),
          // Auth Provider
          ChangeNotifierProvider<AuthProvider>(
            create: (context) => AuthProvider(context.read<Authservices>()),
          ),
          // Stream provider for auth state changes
          StreamProvider<User?>(
            create: (context) => context.read<Authservices>().authStateChanges,
            initialData: null,
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Study Circle',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        textTheme: GoogleFonts.ralewayTextTheme(),
      ),
      home: const Launcher(),
      routes: {
        '/login': (context) => const Login(),
        '/signup': (context) => const SignUp(),
        '/my-groups': (context) => const MyGroupsScreen(),
        '/groups/create': (context) => const CreateGroupScreen(),
        '/groups/detail': (context) => const GroupDetailScreen(),
      },
    );
  }
}
