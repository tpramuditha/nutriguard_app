import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/catalog/recipe_catalog.dart';
import '../../data/models/pantry_item_model.dart';
import '../../data/repositories/pantry_repository.dart';
import '../../data/services/recipe_matching_service.dart';
import 'recipe_details_page.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  static const Color primary = Color(0xFF0D9488);
  static const Color darkGreen = Color(0xFF086F67);
  static const Color background = Color(0xFFF7FAFA);

  final PantryRepository _repository = PantryRepository();
  final RecipeMatchingService _matchingService = const RecipeMatchingService();

  String _selectedFilter = 'All Recipes';

  List<RecipeMatchResult> _getFilteredRecipes(List<RecipeMatchResult> recipes) {
    switch (_selectedFilter) {
      case 'Ready to Cook':
        return recipes.where((result) => result.isReadyToCook).toList();

      case 'Missing a Few':
        return recipes.where((result) => result.isMissingAFew).toList();

      default:
        return recipes;
    }
  }

  IconData _recipeIcon(String recipeId) {
    switch (recipeId) {
      case 'egg_fried_rice':
        return Icons.rice_bowl;
      case 'vegetable_omelette':
        return Icons.egg_alt;
      case 'rice_and_dhal':
        return Icons.soup_kitchen;
      case 'vegetable_stir_fry':
        return Icons.eco;
      case 'boiled_eggs':
        return Icons.egg;
      default:
        return Icons.restaurant;
    }
  }

  String _formatPercentage(double percentage) {
    return '${percentage.round()}%';
  }

  Widget _buildHeader(List<RecipeMatchResult> results) {
    final readyCount = results.where((result) => result.isReadyToCook).length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D9488), Color(0xFF40BFA3)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.white, size: 24),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Cook with what you have!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Explore ${results.length} recipes using '
            'ingredients from your pantry.',
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 7),
                Text(
                  '$readyCount ready to cook',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(List<RecipeMatchResult> results) {
    final readyCount = results.where((result) => result.isReadyToCook).length;

    final missingFewCount = results
        .where((result) => result.isMissingAFew)
        .length;

    final filters = <String, int>{
      'All Recipes': results.length,
      'Ready to Cook': readyCount,
      'Missing a Few': missingFewCount,
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.entries.map((entry) {
          final isSelected = _selectedFilter == entry.key;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              showCheckmark: false,
              label: Text('${entry.key} (${entry.value})'),
              selected: isSelected,
              selectedColor: primary,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : darkGreen,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 12,
              ),
              side: const BorderSide(color: Color(0xFFD8E8E6)),
              onSelected: (_) {
                setState(() {
                  _selectedFilter = entry.key;
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatusBadge(RecipeMatchResult result) {
    final isReady = result.isReadyToCook;

    final label = isReady
        ? 'Ready to Cook'
        : result.isMissingAFew
        ? 'Missing a Few'
        : 'Need More Ingredients';

    final badgeColor = isReady
        ? const Color(0xFF18865A)
        : const Color(0xFFD98319);

    final badgeBackground = isReady
        ? const Color(0xFFE3F6E9)
        : const Color(0xFFFFF0DD);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: badgeBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isReady ? Icons.check_circle_outline : Icons.info_outline,
            color: badgeColor,
            size: 14,
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: badgeColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(RecipeMatchResult result) {
    final recipe = result.recipe;

    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5EEEE)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 86,
                  width: 86,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFDDF6E9), Color(0xFFFFEBCD)],
                    ),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(_recipeIcon(recipe.id), color: primary, size: 39),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF183F43),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${recipe.totalMinutes} min  •  '
                        '${recipe.servings} '
                        '${recipe.servings == 1 ? 'serving' : 'servings'}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF71858A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildStatusBadge(result),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              recipe.description,
              style: const TextStyle(fontSize: 12, color: Color(0xFF617B80)),
            ),
            const SizedBox(height: 13),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${result.matchedIngredients}/'
                  '${result.totalIngredients} ingredients',
                  style: const TextStyle(
                    color: darkGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${_formatPercentage(result.matchPercentage)} match',
                  style: const TextStyle(
                    color: darkGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: result.matchPercentage / 100,
                minHeight: 7,
                backgroundColor: const Color(0xFFE4EFED),
                valueColor: AlwaysStoppedAnimation<Color>(
                  result.isReadyToCook ? primary : const Color(0xFFE6A34B),
                ),
              ),
            ),
            if (!result.isReadyToCook) ...[
              const SizedBox(height: 10),
              Text(
                '${result.unavailableIngredients.length} '
                'ingredient(s) missing or insufficient',
                style: const TextStyle(fontSize: 11, color: Color(0xFFB47625)),
              ),
            ],
            const SizedBox(height: 13),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => RecipeDetailsPage(result: result),
                    ),
                  );
                },
                icon: const Icon(Icons.menu_book_outlined, size: 18),
                label: const Text('View Recipe'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primary,
                  side: const BorderSide(color: primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
      child: Column(
        children: [
          const Icon(Icons.no_food_outlined, size: 55, color: primary),
          const SizedBox(height: 12),
          const Text(
            'No recipes found',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try a different filter or add more '
            'ingredients to your pantry.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedFilter = 'All Recipes';
              });
            },
            child: const Text('Show All Recipes'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(List<PantryItemModel> pantryItems) {
    final allResults = _matchingService.matchRecipes(
      recipes: RecipeCatalog.getAllRecipes(),
      pantryItems: pantryItems,
    );

    final filteredResults = _getFilteredRecipes(allResults);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      children: [
        _buildHeader(allResults),
        const SizedBox(height: 18),
        _buildFilters(allResults),
        const SizedBox(height: 16),
        Text(
          _selectedFilter,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: darkGreen,
          ),
        ),
        const SizedBox(height: 11),
        if (filteredResults.isEmpty)
          _buildEmptyState()
        else
          for (final result in filteredResults) _buildRecipeCard(result),
        const SizedBox(height: 8),
        const Text(
          'Recipe availability is based on your pantry '
          'stock. Nutrition values are estimates.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: Color(0xFF7B9094)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        foregroundColor: darkGreen,
        centerTitle: true,
        title: const Text(
          'Recipes You Can Make',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: user == null
          ? const Center(
              child: Text('Please log in to view recipe suggestions.'),
            )
          : StreamBuilder<List<PantryItemModel>>(
              stream: _repository.watchPantryItems(userId: user.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Unable to load pantry ingredients: '
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: primary),
                  );
                }

                return _buildContent(snapshot.data!);
              },
            ),
    );
  }
}
