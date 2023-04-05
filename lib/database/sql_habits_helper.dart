import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:digital_bullet/database/sql_create_statements.dart';

class SQLHabitsHelper {

  static Future<int> createHabit(String name, String? description) async {
    final db = await SQLHelper.db();

    final data = {
      'name': name,
      'description': description,
    };
    final id = await db.insert('habits', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<int> createHabitCalendar(
      String date, int habitID, int completed) async {
    final db = await SQLHelper.db();

    final data = {
      'habit_id': habitID,
      'date': date,
      'completed': completed,
    };
    final id = await db.insert('habit_calendar', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getHabitCalendar(int id) async {
    final db = await SQLHelper.db();
    return db.query('habit_calendar', where: "habit_id = ?", whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getHabits() async {
    final db = await SQLHelper.db();
    return db.query('habits', orderBy: "habit_id");
  }

  static Future<List<Map<String, dynamic>>> getHabit() async {
    final db = await SQLHelper.db();
    return db.query('habits', where: "habit_id = ?");
  }

  static Future<int> updateHabitCalender(
      int id, String date, int completed) async {
    final db = await SQLHelper.db();

    final data = {
      'date': date,
      'completed': completed,
    };

    final result = await db
        .update('habit_calendar', data, where: "habit_id = ?", whereArgs: [id]);
    return result;
  }

  static Future<int> updateHabit(
      int id, String name, String? description) async {
    final db = await SQLHelper.db();

    final data = {
      'name': name,
      'description': description,
    };

    final result =
        await db.update('habits', data, where: "habit_id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteHabitCalendar(int id, String date) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('habit_calendar',
          where: "habit_id = ? and date = ?", whereArgs: [id, date]);
    } catch (err) {
      debugPrint("Something went wrong where deleting an habit calendar: $err");
    }
  }

  static Future<void> deleteHabit(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('habit_calendar', where: "habit_id = ?", whereArgs: [id]);
      await db.delete('habits', where: "habit_id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an habit: $err");
    }
  }
}
