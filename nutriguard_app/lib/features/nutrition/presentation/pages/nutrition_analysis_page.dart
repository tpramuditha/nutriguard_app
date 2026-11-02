import 'package:flutter/material.dart';

import '../../../food_scanner/data/models/food_log_model.dart';

class NutritionAnalysisPage extends StatelessWidget {
  final FoodLogModel foodLog;

  const NutritionAnalysisPage({super.key, required this.foodLog});

  static const Color _teal = Color(0xFF009B8E);
  static const Color _dark = Color(0xFF073D58);
  static const Color _background = Color(0xFFF4FAFC);

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _macroRow({
    required String title,
    required double grams,
    required IconData icon,
    required Color color,
    required double maxGrams,
  }) {
    final progress = maxGrams > 0 ? (grams / maxGrams).clamp(0.0, 1.0) : 0.0;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _dark,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${grams.toStringAsFixed(1)} g',
                      style: const TextStyle(color: Colors.blueGrey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 9,
                    color: color,
                    backgroundColor: const Color(0xFFEAF1F5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxMacro = [
      foodLog.protein,
      foodLog.carbs,
      foodLog.fat,
    ].reduce((a, b) => a > b ? a : b);

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _background,
        centerTitle: true,
        title: const Text(
          'Nutrition Analysis',
          style: TextStyle(color: _dark, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Food information card
          _card(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1F5ED),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.restaurant, color: _teal, size: 42),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        foodLog.foodName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _dark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${foodLog.grams.toStringAsFixed(0)} g portion',
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        foodLog.mealType,
                        style: const TextStyle(
                          color: _teal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Calories and macronutrients
          _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.local_fire_department, color: _teal),
                    SizedBox(width: 8),
                    Text(
                      'Calories & Macros',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: _dark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  '${foodLog.calories.toStringAsFixed(0)} kcal',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: _dark,
                  ),
                ),
                _macroRow(
                  title: 'Protein',
                  grams: foodLog.protein,
                  icon: Icons.fitness_center,
                  color: const Color(0xFF439DFF),
                  maxGrams: maxMacro,
                ),
                _macroRow(
                  title: 'Carbs',
                  grams: foodLog.carbs,
                  icon: Icons.grain,
                  color: const Color(0xFFFFAE39),
                  maxGrams: maxMacro,
                ),
                _macroRow(
                  title: 'Fat',
                  grams: foodLog.fat,
                  icon: Icons.water_drop,
                  color: const Color(0xFF9B6AFF),
                  maxGrams: maxMacro,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Bars compare the amounts of these three '
                  'macronutrients in this portion.',
                  style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Daily budget section
          _card(
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.pie_chart, color: _teal),
                    SizedBox(width: 8),
                    Text(
                      "Impact on Today's Budget",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: _dark,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  'Your daily calorie goal will appear here '
                  'after we connect your personal nutrition target.',
                  style: TextStyle(color: Colors.blueGrey),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Vitamins and minerals section
          _card(
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.eco, color: _teal),
                    SizedBox(width: 8),
                    Text(
                      'Vitamins & Minerals',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: _dark,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  'Micronutrient data is not available for '
                  'this food log yet.',
                  style: TextStyle(color: Colors.blueGrey),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
