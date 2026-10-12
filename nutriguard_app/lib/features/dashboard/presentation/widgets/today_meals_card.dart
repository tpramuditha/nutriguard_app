import 'package:flutter/material.dart';

import 'meal_suggestion_card.dart';

import '../../../../app/theme/app_colors.dart';

class TodayMealsCard extends StatelessWidget {
  const TodayMealsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Today's Meals",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Food History coming soon')),
                  );
                },
                child: const Text('View All'),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _mealItem(
            context,
            title: 'Breakfast',
            description: 'Oats with banana & berries',
            calories: 420,
            imagePath: 'assets/images/dashboard/breakfast.png',
          ),

          const SizedBox(height: 12),

          _mealItem(
            context,
            title: 'Lunch',
            description: 'Chicken curry with rice & vegetables',
            calories: 620,
            imagePath: 'assets/images/dashboard/lunch.png',
          ),

          const SizedBox(height: 12),

          _mealItem(
            context,
            title: 'Snack',
            description: 'Mixed nuts (30g)',
            calories: 210,
            imagePath: 'assets/images/dashboard/snack.png',
          ),

          const SizedBox(height: 20),

          // Sample AI suggestion banner
          const MealSuggestionCard(),
        ],
      ),
    );
  }

  Widget _mealItem(
    BuildContext context, {
    required String title,
    required String description,
    required int calories,
    required String imagePath,
  }) {
    return Material(
      color: const Color(0xFFF9FCFB),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$title details coming soon')));
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  width: 68,
                  height: 68,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 68,
                      height: 68,
                      color: AppColors.primaryLight,
                      child: const Icon(
                        Icons.restaurant,
                        color: AppColors.primary,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Text(
                '$calories kcal',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(width: 4),

              const Icon(
                Icons.chevron_right,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
