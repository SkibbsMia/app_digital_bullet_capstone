import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'sql_create_statements.dart';

class SQLJournalHelper {
  static Future<int> createAMEntry(String entry) async {
    final db = await SQLHelper.db();

    DateTime date = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final data = {'date': formattedDate, 'entry': entry};
    final id = await db.insert('journal_am_entries', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<int> createPMEntry(String entry) async {
    final db = await SQLHelper.db();

    DateTime date = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final data = {'date': formattedDate, 'entry': entry};
    final id = await db.insert('journal_pm_entries', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAMEntries() async {
    final db = await SQLHelper.db();
    return db.query('journal_am_entries', orderBy: "date ASC");
  }

  static Future<List<Map<String, dynamic>>> getPMEntries() async {
    final db = await SQLHelper.db();
    return db.query('journal_pm_entries', orderBy: "date ASC");
  }

  static Future<List<Map<String, dynamic>>> getAMEntry(String date) async {
    final db = await SQLHelper.db();
    return db.query('journal_am_entries',
        where: "date = ?", whereArgs: [date], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getPMEntry(String date) async {
    final db = await SQLHelper.db();
    return db.query('journal_pm_entries',
        where: "date = ?", whereArgs: [date], limit: 1);
  }

  static Future<int> updateAMEntry(int id, String entry) async {
    final db = await SQLHelper.db();

    final data = {'entry': entry};

    final result = await db
        .update('journal_am_entries', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<int> updatePMEntry(int id, String entry) async {
    final db = await SQLHelper.db();

    final data = {'entry': entry};

    final result = await db
        .update('journal_pm_entries', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteAMEntry(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('journal_am_entries', where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<void> deletePMEntry(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('journal_pm_entries', where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
