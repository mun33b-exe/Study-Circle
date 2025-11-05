import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_circle/firebase_options.dart';
import 'package:study_circle/screens/launcher.dart';
import 'package:study_circle/screens/sign_up.dart';
import 'package:study_circle/screens/login_ui.dart';
import 'package:provider/provider.dart';
import 'package:study_circle/provider/authprovider.dart';
import 'package:study_circle/services/authservices.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        // Firebase Auth Service provider
        Provider<Authservices>(create: (_) => Authservices()),
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
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
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
        },
      ),
    );
  }
}
