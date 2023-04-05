import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:digital_bullet/database/sql_create_statements.dart';

class SQLToDoHelper {
  static Future<int> createItem(
      String title, String? description, String timestamp) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': description,
      'dueDate': timestamp
    };
    final id = await db.insert('to_do_items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    var date = DateTime.now();
    DateTime newDate = date.subtract(const Duration(days: 31));
    String formattedDate = DateFormat('yyyy-MM-dd').format(newDate);
    return db.query('to_do_items',
        where:
            "completed = 1 OR (dueDate > '$formattedDate' AND completed = 0)",
        orderBy: 'completed DESC, dueDate ASC');
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('to_do_items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(
      int id, String title, String? description, String timeStamp) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': description,
      'createdAt': DateTime.now().toString(),
      'dueDate': timeStamp
    };

    final result =
        await db.update('to_do_items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<int> isCompleted(int id, int completed) async {
    final db = await SQLHelper.db();

    final data = {
      'completed': completed,
    };

    final result =
        await db.update('to_do_items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('to_do_items', where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
