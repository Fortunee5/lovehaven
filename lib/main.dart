// lib/main.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/content_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/home_screen.dart';
import 'screens/about_screen.dart';
import 'screens/sermons_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/staff_screen.dart';
import 'screens/next_steps_screen.dart';
import 'screens/live_screen.dart';
import 'screens/visit_screen.dart';
import 'screens/admin/admin_login_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => AboutScreen(),
      ),
      GoRoute(
        path: '/sermons',
        builder: (context, state) => SermonsScreen(),
      ),
      GoRoute(
        path: '/calendar',
        builder: (context, state) => CalendarScreen(),
      ),
      GoRoute(
        path: '/staff',
        builder: (context, state) => StaffScreen(),
      ),
      GoRoute(
        path: '/next-steps',
        builder: (context, state) => NextStepsScreen(),
      ),
      GoRoute(
        path: '/live',
        builder: (context, state) => LiveScreen(),
      ),
      GoRoute(
        path: '/visit',
        builder: (context, state) => VisitScreen(),
      ),
      GoRoute(
        path: '/admin-login',
        builder: (context, state) => AdminLoginScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => AdminDashboardScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ContentProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp.router(
        title: 'CELVZLOVEHAVEN',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFF2E8B57), // Teal-green
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFF2E8B57),
            primary: Color(0xFF2E8B57),
            secondary: Color(0xFF20B2AA),
          ),
          textTheme: GoogleFonts.montserratTextTheme(),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2E8B57),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        routerConfig: _router,
      ),
    );
  }
}