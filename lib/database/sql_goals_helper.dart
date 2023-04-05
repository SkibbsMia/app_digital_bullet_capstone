import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:digital_bullet/database/sql_create_statements.dart';

class SQLGoalsHelper {
  static Future<int> createGoal(
      String name, String? description, int percentage) async {
    final db = await SQLHelper.db();

    final data = {
      'name': name,
      'description': description,
      'percentage': percentage,
    };
    final id = await db.insert('goals', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getGoals() async {
    final db = await SQLHelper.db();
    return db.query('goals', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getGoal() async {
    final db = await SQLHelper.db();
    return db.query('goals', where: "id = ?");
  }

  static Future<int> updateGoal(
      int id, String name, String? description, int percentage) async {
    final db = await SQLHelper.db();

    final data = {
      'name': name,
      'description': description,
      'percentage': percentage,
    };

    final result =
        await db.update('goals', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<int> updatePercentage(int id, int percentage) async {
    final db = await SQLHelper.db();

    final data = {
      'percentage': percentage,
    };

    final result =
        await db.update('goals', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteGoal(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('goals', where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an goal: $err");
    }
  }
}
