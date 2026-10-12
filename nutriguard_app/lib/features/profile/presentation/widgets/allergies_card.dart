import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class AllergiesCard extends StatefulWidget {
  const AllergiesCard({super.key});

  @override
  State<AllergiesCard> createState() => _AllergiesCardState();
}

class _AllergiesCardState extends State<AllergiesCard> {
  // Sample allergies for UI development
  final List<String> _allergies = ['Peanuts', 'Shellfish'];

  Future<void> _addAllergy() async {
    String allergyName = '';

    final newAllergy = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Food Allergy'),

          content: TextFormField(
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Allergy name',
              hintText: 'e.g. Milk',
            ),
            onChanged: (value) {
              allergyName = value;
            },
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                final name = allergyName.trim();

                if (name.isEmpty) {
                  return;
                }

                Navigator.pop(dialogContext, name);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (!mounted || newAllergy == null) return;

    // Prevent duplicate allergies
    final alreadyExists = _allergies.any(
      (allergy) => allergy.toLowerCase() == newAllergy.toLowerCase(),
    );

    if (alreadyExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This allergy is already added.')),
      );
      return;
    }

    setState(() {
      _allergies.add(newAllergy);
    });
  }

  void _removeAllergy(String allergy) {
    setState(() {
      _allergies.remove(allergy);
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
              Icon(
                Icons.warning_amber_rounded,
                color: AppColors.primary,
                size: 26,
              ),
              SizedBox(width: 10),
              Text(
                'Allergies',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          if (_allergies.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'No allergies added',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _allergies.map((allergy) {
              return Chip(
                label: Text(allergy),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () {
                  _removeAllergy(allergy);
                },
                backgroundColor: const Color(0xFFFFF2E8),
                deleteIconColor: const Color(0xFFE65100),
                labelStyle: const TextStyle(
                  color: Color(0xFFE65100),
                  fontWeight: FontWeight.w500,
                ),
                side: const BorderSide(color: Color(0xFFFFD5B2)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 12),

          TextButton.icon(
            onPressed: _addAllergy,
            icon: const Icon(Icons.add),
            label: const Text('Add Allergy'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
