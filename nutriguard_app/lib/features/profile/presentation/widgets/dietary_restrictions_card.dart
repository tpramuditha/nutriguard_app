import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class DietaryRestrictionsCard extends StatefulWidget {
  const DietaryRestrictionsCard({super.key});

  @override
  State<DietaryRestrictionsCard> createState() =>
      _DietaryRestrictionsCardState();
}

class _DietaryRestrictionsCardState extends State<DietaryRestrictionsCard> {
  // Temporary selections for UI development
  final Set<String> _selectedRestrictions = {'Halal'};

  final List<String> _restrictions = [
    'Vegetarian',
    'Vegan',
    'Halal',
    'Pescatarian',
    'None',
  ];

  void _toggleRestriction(String restriction) {
    setState(() {
      if (restriction == 'None') {
        _selectedRestrictions.clear();
        _selectedRestrictions.add('None');
        return;
      }

      // Remove None when selecting another restriction
      _selectedRestrictions.remove('None');

      if (_selectedRestrictions.contains(restriction)) {
        _selectedRestrictions.remove(restriction);
      } else {
        _selectedRestrictions.add(restriction);
      }

      if (_selectedRestrictions.isEmpty) {
        _selectedRestrictions.add('None');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.restaurant, color: AppColors.primary, size: 26),
              SizedBox(width: 10),
              Text(
                'Dietary Restrictions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _restrictions.map((restriction) {
              final isSelected = _selectedRestrictions.contains(restriction);

              return FilterChip(
                label: Text(restriction),
                selected: isSelected,
                showCheckmark: false,
                selectedColor: AppColors.primary,
                backgroundColor: Colors.white,
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primary
                      : const Color(0xFFB5E7D7),
                ),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.primaryDark,
                  fontWeight: FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                onSelected: (_) {
                  _toggleRestriction(restriction);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
