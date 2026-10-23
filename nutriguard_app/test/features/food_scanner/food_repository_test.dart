import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:nutriguard_app/features/food_scanner/data/repositories/food_repository.dart';

void main() {
  test('search returns foods with valid nutrition data', () async {
    final client = MockClient((request) async {
      expect(request.url.host, 'world.openfoodfacts.org');
      expect(request.url.queryParameters['search_terms'], 'oats');

      return http.Response(
        jsonEncode({
          'products': [
            {
              'code': '123456',
              'product_name': 'Test Oats',
              'brands': 'Example Brand',
              'nutriments': {
                'energy-kcal_100g': 380,
                'proteins_100g': 13,
                'carbohydrates_100g': 67,
                'fat_100g': 7,
              },
            },
          ],
        }),
        200,
      );
    });

    final repository = FoodRepository(client: client);

    final results = await repository.searchFoods('oats');

    expect(results.length, 1);
    expect(results.first.id, '123456');
    expect(results.first.name, 'Test Oats');
    expect(results.first.brand, 'Example Brand');
    expect(results.first.source, 'Open Food Facts');

    expect(results.first.caloriesPer100g, 380);
    expect(results.first.proteinPer100g, 13);
    expect(results.first.carbsPer100g, 67);
    expect(results.first.fatPer100g, 7);

    repository.dispose();
  });

  test('missing nutritional information is not treated as zero', () async {
    final client = MockClient((request) async {
      return http.Response(
        jsonEncode({
          'products': [
            {
              'code': '111',
              'product_name': 'Incomplete Food',
              'nutriments': {
                'energy-kcal_100g': 100,
                'proteins_100g': 3,
                'carbohydrates_100g': 20,
                // Fat is missing.
              },
            },
          ],
        }),
        200,
      );
    });

    final repository = FoodRepository(client: client);

    final results = await repository.searchFoods('food');

    expect(results, isEmpty);

    repository.dispose();
  });

  test('empty search returns no results without an API request', () async {
    var requestCount = 0;

    final client = MockClient((request) async {
      requestCount++;
      return http.Response('{"products":[]}', 200);
    });

    final repository = FoodRepository(client: client);

    final results = await repository.searchFoods('   ');

    expect(results, isEmpty);
    expect(requestCount, 0);

    repository.dispose();
  });

  test('API errors are reported correctly', () async {
    final client = MockClient((request) async {
      return http.Response('Server Error', 500);
    });

    final repository = FoodRepository(client: client);

    await expectLater(
      repository.searchFoods('rice'),
      throwsA(isA<Exception>()),
    );

    repository.dispose();
  });

  test('nutrition values are converted to portion calculations', () async {
    final client = MockClient((request) async {
      return http.Response(
        jsonEncode({
          'products': [
            {
              'code': '789',
              'product_name': 'Example Rice',
              'nutriments': {
                'energy-kcal_100g': 130,
                'proteins_100g': 2.7,
                'carbohydrates_100g': 28.2,
                'fat_100g': 0.3,
              },
            },
          ],
        }),
        200,
      );
    });

    final repository = FoodRepository(client: client);

    final results = await repository.searchFoods('rice');

    expect(results.length, 1);

    final food = results.first;

    expect(food.caloriesForGrams(150), closeTo(195, 0.001));
    expect(food.proteinForGrams(150), closeTo(4.05, 0.001));
    expect(food.carbsForGrams(150), closeTo(42.3, 0.001));

    repository.dispose();
  });
}
