import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ordogital.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id            INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name     TEXT    NOT NULL,
        phone         TEXT,
        role          TEXT    NOT NULL,
        access_key    TEXT    UNIQUE,
        ministry_type TEXT,
        is_active     INTEGER NOT NULL DEFAULT 1,
        created_at    TEXT    NOT NULL DEFAULT (datetime('now'))
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS mass_schedules (
        id            INTEGER PRIMARY KEY AUTOINCREMENT,
        title         TEXT NOT NULL,
        mass_date     TEXT NOT NULL,
        mass_time     TEXT NOT NULL,
        is_recurring  INTEGER NOT NULL DEFAULT 0,
        recurrence    TEXT,
        day_of_week   INTEGER,
        notes         TEXT,
        created_at    TEXT NOT NULL DEFAULT (datetime('now'))
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS duty_assignments (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        schedule_id     INTEGER NOT NULL,
        user_id         INTEGER NOT NULL,
        role_assigned   TEXT NOT NULL,
        sms_sent        INTEGER NOT NULL DEFAULT 0,
        confirmed       INTEGER NOT NULL DEFAULT 0,
        created_at      TEXT NOT NULL DEFAULT (datetime('now')),
        FOREIGN KEY (schedule_id) REFERENCES mass_schedules(id),
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS liturgical_readings (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        reading_date    TEXT NOT NULL,
        season          TEXT NOT NULL,
        first_reading   TEXT,
        responsorial    TEXT,
        second_reading  TEXT,
        gospel          TEXT,
        gospel_verse    TEXT,
        created_at      TEXT NOT NULL DEFAULT (datetime('now'))
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS parish_projects (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        title           TEXT NOT NULL,
        description     TEXT,
        goal_amount     REAL NOT NULL DEFAULT 0,
        current_amount  REAL NOT NULL DEFAULT 0,
        start_date      TEXT,
        target_date     TEXT,
        is_completed    INTEGER NOT NULL DEFAULT 0,
        updated_at      TEXT NOT NULL DEFAULT (datetime('now'))
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS announcements (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        title        TEXT NOT NULL,
        body         TEXT,
        category     TEXT,
        target_role  TEXT NOT NULL DEFAULT 'all',
        publish_at   TEXT NOT NULL DEFAULT (datetime('now')),
        expires_at   TEXT,
        is_active    INTEGER NOT NULL DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS hymns (
        id        INTEGER PRIMARY KEY AUTOINCREMENT,
        title     TEXT NOT NULL,
        lyrics    TEXT,
        category  TEXT,
        language  TEXT NOT NULL DEFAULT 'Filipino',
        season    TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS trivia_questions (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        question        TEXT NOT NULL,
        option_a        TEXT NOT NULL,
        option_b        TEXT NOT NULL,
        option_c        TEXT NOT NULL,
        option_d        TEXT NOT NULL,
        correct_option  TEXT NOT NULL,
        explanation     TEXT,
        season          TEXT,
        difficulty      TEXT NOT NULL DEFAULT 'easy'
      )
    ''');

    await _seedAdminUser(db);
  }

  Future<void> _seedAdminUser(Database db) async {
    await db.insert('users', {
      'full_name': 'Parish Admin',
      'role': 'admin',
      'is_active': 1,
    });
  }

  // Generic helpers
  Future<int> insert(String table, Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert(
      table,
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryWhere(
    String table,
    String where,
    List<dynamic> args,
  ) async {
    final db = await database;
    return await db.query(table, where: where, whereArgs: args);
  }

  Future<int> update(
    String table,
    Map<String, dynamic> row,
    String where,
    List<dynamic> args,
  ) async {
    final db = await database;
    return await db.update(table, row, where: where, whereArgs: args);
  }

  Future<int> delete(String table, String where, List<dynamic> args) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: args);
  }
}
