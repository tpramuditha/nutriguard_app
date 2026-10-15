import 'package:flutter/material.dart';

import '../../../../app/routes/route_names.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _action(
          context,
          'Scan Food',
          Icons.camera_alt_outlined,
          const Color(0xFFB4F3E5),
          const Color(0xFF008E83),
        ),
        _action(
          context,
          'Pantry',
          Icons.shopping_basket_outlined,
          const Color(0xFFC8F4C8),
          const Color(0xFF159F52),
        ),
        _action(
          context,
          'Planner',
          Icons.calendar_month_outlined,
          const Color(0xFFD0E3FF),
          const Color(0xFF237BD2),
        ),
        _action(
          context,
          'Health',
          Icons.favorite_outline,
          const Color(0xFFFFD5E1),
          const Color(0xFFE74770),
        ),
      ],
    );
  }

  Widget _action(
    BuildContext context,
    String title,
    IconData icon,
    Color background,
    Color iconColor,
  ) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),

        onTap: () {
          // Navigate to Health Profile
          if (title == 'Health') {
            Navigator.pushNamed(context, RouteNames.health);
            return;
          }

          // Other quick actions are not implemented yet
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$title page is coming soon')));
        },

        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: iconColor),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
