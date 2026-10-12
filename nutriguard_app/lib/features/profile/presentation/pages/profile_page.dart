import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../widgets/profile_header.dart';
import '../widgets/personal_goals_card.dart';
import '../widgets/dietary_restrictions_card.dart';
import '../widgets/allergies_card.dart';
import '../widgets/notification_settings_card.dart';
import '../widgets/units_card.dart';
import '../../../../app/routes/route_names.dart';
import '../../../../core/services/firebase/firebase_auth_service.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';

import '../widgets/account_settings_card.dart';
import '../widgets/logout_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuthService _authService = FirebaseAuthService();

  bool _isLoggingOut = false;

  Future<void> _confirmLogout() async {
    if (_isLoggingOut) return;

    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (_) => const LogoutDialog(),
    );

    if (!mounted || shouldLogout != true) return;

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
    if (index == 4) return;

    if (index == 0) {
      Navigator.pop(context);
      return;
    }

    const pages = ['Home', 'Scanner', 'Planner', 'Progress', 'Profile'];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${pages[index]} page is coming soon.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFC),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF5FAFC),
        centerTitle: true,
        title: const Text(
          'Profile & Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile editing coming soon.')),
              );
            },
            child: const Text('Edit'),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ProfileHeader(),

            SizedBox(height: 16),

            PersonalGoalsCard(),

            SizedBox(height: 16),

            DietaryRestrictionsCard(),

            SizedBox(height: 16),

            AllergiesCard(),

            SizedBox(height: 16),

            NotificationSettingsCard(),

            SizedBox(height: 16),

            UnitsCard(),

            const SizedBox(height: 16),

            AccountSettingsCard(onLogout: _confirmLogout),

            const SizedBox(height: 24),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: 4,
        onTap: _onBottomNavTap,
      ),
    );
  }
}
