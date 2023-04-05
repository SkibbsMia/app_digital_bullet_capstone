import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE journal_pm_entries(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    date TEXT NOT NULL,
    entry TEXT NOT NULL
    )
    """);
    await database.execute("""CREATE TABLE journal_am_entries(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    date TEXT NOT NULL, 
    entry TEXT NOT NULL
    )
    """);
    await database.execute("""CREATE TABLE habits(
    habit_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    name TEXT,
    description TEXT
    )
    """);
    await database.execute("""CREATE TABLE goals(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    name TEXT,
    description TEXT,
    percentage INTEGER
    )
    """);
    await database.execute("""CREATE TABLE habit_calendar(
    habit_calender_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    habit_id INTEGER,
    date TEXT,
    completed INTEGER,
    FOREIGN KEY (habit_id) REFERENCES habits(habit_id)
    )
    """);
    await database.execute("""CREATE TABLE to_do_items(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title TEXT,
    description TEXT,
    completed INTEGER NOT NULL DEFAULT 1,
    dueDate TEXT NOT NULL,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
    await database.execute("""CREATE TABLE notes(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title TEXT,
    note TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('bullet.db', version: 1,
        onCreate: (sql.Database database, int version) async {
          await createTables(database);
        });
  }
}