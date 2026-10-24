import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/food_log_model.dart';

class FoodLogRepository {
  final FirebaseFirestore _firestore;

  FoodLogRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _foodLogs(String userId) {
    if (userId.trim().isEmpty) {
      throw ArgumentError('A valid user ID is required.');
    }

    return _firestore.collection('users').doc(userId).collection('foodLogs');
  }

  Future<String> saveFoodLog({
    required String userId,
    required FoodLogModel foodLog,
  }) async {
    final document = await _foodLogs(userId).add(foodLog.toMap());

    return document.id;
  }

  Future<List<FoodLogModel>> getFoodLogs({required String userId}) async {
    final snapshot = await _foodLogs(userId)
        .orderBy('loggedAt', descending: true)
        .get();

    return snapshot.docs.map((document) {
      return FoodLogModel.fromMap(document.data());
    }).toList();
  }
}
