import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'sql_create_statements.dart';

class SQLNotesHelper {
  static Future<int> createNote(String title, String note) async {
    final db = await SQLHelper.db();

    final data = {'title': title, 'note': note};
    final id = await db.insert('notes', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await SQLHelper.db();
    return db.query('notes', orderBy: "createdAt ASC");
  }

  static Future<List<Map<String, dynamic>>> getNote(int id) async {
    final db = await SQLHelper.db();
    return db.query('notes', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateNote(int id, String title, String? note) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'note': note,
      'createdAt': DateTime.now().toString(),
    };

    final result =
        await db.update('notes', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteNote(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('notes', where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
