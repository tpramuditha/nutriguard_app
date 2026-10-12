import 'package:flutter/material.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/services/firebase/firebase_auth_service.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../../profile/presentation/widgets/logout_dialog.dart';

import '../widgets/macro_chart.dart';
import '../widgets/quick_actions.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/calorie_progress_card.dart';
import '../widgets/today_meals_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final FirebaseAuthService _authService = FirebaseAuthService();

  bool _isLoggingOut = false;

  Future<void> _logout() async {
    setState(() {
      _isLoggingOut = true;
    });

    try {
      await _authService.signOut();

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.login,
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed. Please try again.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  void _onBottomNavTap(int index) {
    // Index 0 = Home
    if (index == 0) {
      return;
    }

    // Index 4 = Profile
    if (index == 4) {
      Navigator.pushNamed(context, RouteNames.profile);
      return;
    }

    // Other pages are not implemented yet
    const pages = ['Home', 'Scanner', 'Planner', 'Progress', 'Profile'];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${pages[index]} page is coming soon.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => const LogoutDialog(),
    );

    if (!mounted) return;

    if (shouldLogout == true) {
      await _logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFC),

      appBar: AppBar(
        title: const Text(
          'NutriGuard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        backgroundColor: const Color(0xFFF5FAFC),

        actions: [
          PopupMenuButton<String>(
            enabled: !_isLoggingOut,
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'logout') {
                _confirmLogout();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'logout', child: Text('Log Out')),
            ],
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header with Firebase username
            const DashboardHeader(),

            const SizedBox(height: 24),

            // Sample values for UI development
            const CalorieProgressCard(
              consumedCalories: 1450,
              targetCalories: 2000,
              burnedCalories: 120,
            ),

            const SizedBox(height: 24),

            // Macronutrient progress
            const MacroChart(),

            const SizedBox(height: 28),

            // Quick access to main features
            const QuickActions(),

            const SizedBox(height: 24),

            // Today's Meals
            const TodayMealsCard(),

            const SizedBox(height: 24),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: _onBottomNavTap,
      ),
    );
  }
}
