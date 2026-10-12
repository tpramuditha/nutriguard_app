import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../widgets/meal_type_selector.dart';
import '../widgets/health_filter_banner.dart';
import '../widgets/meal_card.dart';
import '../widgets/more_meal_options.dart';

class MealRecommendationPage extends StatefulWidget {
  const MealRecommendationPage({super.key});

  @override
  State<MealRecommendationPage> createState() => _MealRecommendationPageState();
}

class _MealRecommendationPageState extends State<MealRecommendationPage> {
  String _selectedMeal = 'Lunch';

  void _onBottomNavTap(int index) {
    if (index == 0) {
      // Return to Dashboard (Home)
      Navigator.pop(context);
      return;
    }

    const pages = ['Home', 'Scanner', 'Planner', 'Progress', 'Profile'];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${pages[index]} page is coming soon.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFC),

      appBar: AppBar(
        title: const Text(
          'Meal Recommendations',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF5FAFC),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Meal filters coming soon')),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Meal type selection
                Expanded(
                  child: MealTypeSelector(
                    selectedMeal: _selectedMeal,
                    onMealSelected: (meal) {
                      setState(() {
                        _selectedMeal = meal;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 8),

                // Sample user goal
                ActionChip(
                  avatar: const Icon(
                    Icons.track_changes,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  label: const Text(
                    'Weight Loss',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  backgroundColor: const Color(0xFFE1F7EE),
                  side: const BorderSide(color: AppColors.primary),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('User goals will be connected later.'),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            const HealthFilterBanner(
              healthMarkers: ['High Blood Pressure', 'High Cholesterol'],
            ),

            const SizedBox(height: 24),

            // Featured meal recommendation (sample data)
            const MealCard(),

            const SizedBox(height: 28),

            // Alternative meal recommendations
            const MoreMealOptions(),

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
