class RecipeIngredient {
  final String name;
  final double quantity;
  final String unit;

  const RecipeIngredient({
    required this.name,
    required this.quantity,
    required this.unit,
  });
}

class RecipeModel {
  final String id;
  final String name;
  final String description;

  final int preparationMinutes;
  final int cookingMinutes;
  final int servings;

  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  final List<RecipeIngredient> ingredients;
  final List<String> instructions;

  final String? imageUrl;

  const RecipeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.preparationMinutes,
    required this.cookingMinutes,
    required this.servings,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.ingredients,
    required this.instructions,
    this.imageUrl,
  });

  int get totalMinutes {
    return preparationMinutes + cookingMinutes;
  }
}
