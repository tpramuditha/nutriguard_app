import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/auth_gate.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/meals/presentation/pages/meal_recommendation_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/health/presentation/pages/health_profile_page.dart';
import '../../features/health/presentation/pages/log_health_marker_page.dart';
import '../../features/health/presentation/pages/add_health_report_page.dart';
import '../../features/health/presentation/pages/confirm_detected_values_page.dart';
import '../../features/health/presentation/pages/scan_health_report_page.dart';
import '../../features/food_scanner/presentation/pages/food_scanner_page.dart';
import 'route_names.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.welcome:
        return MaterialPageRoute(builder: (_) => const AuthGate());

      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case RouteNames.signup:
        return MaterialPageRoute(builder: (_) => const SignupPage());

      case RouteNames.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardPage());

      case RouteNames.foodScanner:
        return MaterialPageRoute(builder: (_) => const FoodScannerPage());

      case RouteNames.mealRecommendation:
        return MaterialPageRoute(
          builder: (_) => const MealRecommendationPage(),
        );

      case RouteNames.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());

      case RouteNames.health:
        return MaterialPageRoute(builder: (_) => const HealthProfilePage());

      case RouteNames.logHealthMarker:
        final selectedMonth = settings.arguments as DateTime?;

        return MaterialPageRoute(
          builder: (_) => LogHealthMarkerPage(selectedMonth: selectedMonth),
        );

      case RouteNames.addHealthReport:
        return MaterialPageRoute(builder: (_) => const AddHealthReportPage());

      case RouteNames.confirmDetectedValues:
        return MaterialPageRoute(
          builder: (_) => const ConfirmDetectedValuesPage(),
        );

      case RouteNames.scanHealthReport:
        return MaterialPageRoute(builder: (_) => const ScanHealthReportPage());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
