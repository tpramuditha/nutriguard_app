import 'package:cloud_firestore/cloud_firestore.dart';

class FoodLogModel {
  final String foodId;
  final String foodName;
  final String? brand;
  final String source;

  final double grams;
  final String mealType;

  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  final DateTime loggedAt;

  const FoodLogModel({
    required this.foodId,
    required this.foodName,
    this.brand,
    required this.source,
    required this.grams,
    required this.mealType,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.loggedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'foodId': foodId,
      'foodName': foodName,
      'brand': brand,
      'source': source,
      'grams': grams,
      'mealType': mealType,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'loggedAt': Timestamp.fromDate(loggedAt),
    };
  }

  factory FoodLogModel.fromMap(Map<String, dynamic> map) {
    return FoodLogModel(
      foodId: map['foodId'] as String,
      foodName: map['foodName'] as String,
      brand: map['brand'] as String?,
      source: map['source'] as String,
      grams: (map['grams'] as num).toDouble(),
      mealType: map['mealType'] as String,
      calories: (map['calories'] as num).toDouble(),
      protein: (map['protein'] as num).toDouble(),
      carbs: (map['carbs'] as num).toDouble(),
      fat: (map['fat'] as num).toDouble(),
      loggedAt: (map['loggedAt'] as Timestamp).toDate(),
    );
  }
}
