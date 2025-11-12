import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/journal_screen.dart';
import 'screens/activities_screen.dart';
import 'screens/meditation_screen.dart';
import 'screens/community_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/premium_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const HealingHeartApp());
}

class HealingHeartApp extends StatelessWidget {
  const HealingHeartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healing Heart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B4CE6),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B4CE6),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const HomeScreen(),
        '/journal': (context) => const JournalScreen(),
        '/activities': (context) => const ActivitiesScreen(),
        '/meditation': (context) => const MeditationScreen(),
        '/community': (context) => const CommunityScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/premium': (context) => const PremiumScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
