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
      CREATE TABLE IF NOT EXISTS collections (
        id            INTEGER PRIMARY KEY AUTOINCREMENT,
        project_id    INTEGER,
        amount        REAL NOT NULL,
        source        TEXT,
        collected_at  TEXT NOT NULL DEFAULT (datetime('now')),
        notes         TEXT,
        FOREIGN KEY (project_id) REFERENCES parish_projects(id)
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
    await _seedSampleData(db);
  }

  Future<void> _seedAdminUser(Database db) async {
    await db.insert('users', {
      'full_name': 'Parish Admin',
      'role': 'admin',
      'is_active': 1,
    });
  }

  Future<void> _seedSampleData(Database db) async {
    // Ministry members
    await db.insert('users', {
      'full_name': 'Kim Benavidez',
      'phone': '091257488356',
      'role': 'ministry',
      'access_key': 'MINISTRY001',
      'ministry_type': 'lector',
      'is_active': 1,
    });
    await db.insert('users', {
      'full_name': 'Juan dela Cruz',
      'phone': '09181234567',
      'role': 'ministry',
      'access_key': 'MINISTRY002',
      'ministry_type': 'altar_server',
      'is_active': 1,
    });
    await db.insert('users', {
      'full_name': 'Maria Santos',
      'phone': '09191234567',
      'role': 'ministry',
      'access_key': 'MINISTRY003',
      'ministry_type': 'commentator',
      'is_active': 1,
    });
    await db.insert('users', {
      'full_name': 'Pedro Reyes',
      'phone': '09201234567',
      'role': 'ministry',
      'access_key': 'MINISTRY004',
      'ministry_type': 'lector',
      'is_active': 1,
    });

    // Mass schedules
    await db.insert('mass_schedules', {
      'title': 'Sunday Mass',
      'mass_date': '2026-04-13',
      'mass_time': '08:00',
      'is_recurring': 1,
      'recurrence': 'weekly',
      'day_of_week': 0,
      'notes': 'Anticipated Mass',
    });
    await db.insert('mass_schedules', {
      'title': 'Sunday Mass',
      'mass_date': '2026-04-13',
      'mass_time': '10:00',
      'is_recurring': 1,
      'recurrence': 'weekly',
      'day_of_week': 0,
      'notes': 'Main Mass',
    });
    await db.insert('mass_schedules', {
      'title': 'Weekday Mass',
      'mass_date': '2026-04-13',
      'mass_time': '06:00',
      'is_recurring': 1,
      'recurrence': 'daily',
      'day_of_week': null,
      'notes': 'Monday to Saturday',
    });

    // Duties para kay Kim (user_id: 2) — Lector
    await db.insert('duty_assignments', {
      'schedule_id': 1,
      'user_id': 2,
      'role_assigned': 'lector',
      'sms_sent': 0,
      'confirmed': 0,
    });
    await db.insert('duty_assignments', {
      'schedule_id': 2,
      'user_id': 2,
      'role_assigned': 'lector',
      'sms_sent': 0,
      'confirmed': 0,
    });

    // Duties para kay Juan (user_id: 3) — Altar Server
    await db.insert('duty_assignments', {
      'schedule_id': 1,
      'user_id': 3,
      'role_assigned': 'altar_server',
      'sms_sent': 0,
      'confirmed': 0,
    });
    await db.insert('duty_assignments', {
      'schedule_id': 3,
      'user_id': 3,
      'role_assigned': 'altar_server',
      'sms_sent': 0,
      'confirmed': 0,
    });

    // Duties para kay Maria (user_id: 4) — Commentator
    await db.insert('duty_assignments', {
      'schedule_id': 2,
      'user_id': 4,
      'role_assigned': 'commentator',
      'sms_sent': 0,
      'confirmed': 0,
    });
    await db.insert('duty_assignments', {
      'schedule_id': 3,
      'user_id': 4,
      'role_assigned': 'commentator',
      'sms_sent': 0,
      'confirmed': 0,
    });

    // Duties para kay Pedro (user_id: 5) — Lector
    await db.insert('duty_assignments', {
      'schedule_id': 3,
      'user_id': 5,
      'role_assigned': 'lector',
      'sms_sent': 0,
      'confirmed': 0,
    });

    // Announcements
    await db.insert('announcements', {
      'title': 'Fiesta ng Parokya',
      'body':
          'Ipinaaabot ng aming parokya ang mainit na imbitasyon sa lahat ng mananampalataya para sa darating na pagdiriwang ng ating patron saint. Mayroon tayong espesyal na Solemn Mass, procesyon, at cultural program.',
      'category': 'feast',
      'target_role': 'all',
      'is_active': 1,
    });
    await db.insert('announcements', {
      'title': 'Youth Ministry Meeting',
      'body':
          'Ang lahat ng miyembro ng Youth Ministry ay inaanyayahang dumalo sa aming monthly meeting sa Sabado, Abril 18, 2026 sa Parish Hall.',
      'category': 'activity',
      'target_role': 'all',
      'is_active': 1,
    });
    await db.insert('announcements', {
      'title': 'Urgent: Pagbabago ng Mass Schedule',
      'body':
          'Abiso sa lahat ng mananampalataya — ang Linggo ng Abril 20 ay magkakaroon ng espesyal na schedule dahil sa Easter Sunday celebrations.',
      'category': 'urgent',
      'target_role': 'all',
      'is_active': 1,
    });

    // Parish projects
    await db.insert('parish_projects', {
      'title': 'Church Renovation',
      'description':
          'Pagpapaayos ng bubong at pader ng simbahan para sa kaligtasan ng lahat ng mananampalataya.',
      'goal_amount': 500000,
      'current_amount': 325000,
      'start_date': '2026-01-01',
      'target_date': '2026-12-31',
      'is_completed': 0,
    });
    await db.insert('parish_projects', {
      'title': 'New Parish Hall',
      'description':
          'Pagtatayo ng bagong Parish Hall para sa mga aktibidad ng komunidad.',
      'goal_amount': 1000000,
      'current_amount': 450000,
      'start_date': '2026-02-01',
      'target_date': '2027-06-30',
      'is_completed': 0,
    });
    await db.insert('parish_projects', {
      'title': 'Sound System',
      'description': 'Pagbili ng bagong sound system para sa simbahan.',
      'goal_amount': 80000,
      'current_amount': 80000,
      'start_date': '2026-01-15',
      'target_date': '2026-03-01',
      'is_completed': 1,
    });

    // Hymns
    await db.insert('hymns', {
      'title': 'Papuri sa Diyos',
      'lyrics':
          'Papuri sa Diyos sa kaitaasan\nAt sa lupa ay kapayapaan\nSa mga taong kinalulugdan Niya\nPupurihin Ka namin\nBendisyunan Ka namin\nSasambahin Ka namin\nLuluwalhatiin Ka namin\nPasasalamat sa Iyo\nDahil sa Iyong dakilang kaluwalhatian',
      'category': 'entrance',
      'language': 'Filipino',
    });
    await db.insert('hymns', {
      'title': 'Ang Katawan ni Kristo',
      'lyrics':
          'Ang katawan ni Kristo\nAmen\nAng dugo ni Kristo\nAmen\nTanggapin nating may pananampalataya\nAng tinapay ng buhay\nAng kalis ng kaligtasan',
      'category': 'communion',
      'language': 'Filipino',
    });
    await db.insert('hymns', {
      'title': 'Banal na Ama',
      'lyrics':
          'Banal na Ama\nNandito kami sa Iyong harapan\nMay pagmamahal at pagsamba\nSa Iyong pangalan\nAng buhay namin ay alay sa Iyo\nTanggapin Mo kami\nO Panginoon',
      'category': 'offertory',
      'language': 'Filipino',
    });
    await db.insert('hymns', {
      'title': 'Magpuri Tayo',
      'lyrics':
          'Magpuri tayo sa Panginoon\nMagpasalamat sa Kanyang mga biyaya\nAng Kanyang pag-ibig ay walang hanggan\nAt ang Kanyang awa ay bago araw-araw',
      'category': 'recessional',
      'language': 'Filipino',
    });

    // Trivia questions
    await db.insert('trivia_questions', {
      'question': 'Anong kulay ang ginagamit sa panahon ng Advent?',
      'option_a': 'Puti',
      'option_b': 'Pula',
      'option_c': 'Lila/Ube',
      'option_d': 'Berde',
      'correct_option': 'c',
      'explanation':
          'Ang lila o ube ay simbolo ng pagsisisi at paghihintay sa pagdating ng Panginoon sa panahon ng Advent.',
      'season': 'advent',
      'difficulty': 'easy',
    });
    await db.insert('trivia_questions', {
      'question': 'Anong tinatawag sa unang pagbabasa sa Misa?',
      'option_a': 'Ebanghelyo',
      'option_b': 'First Reading',
      'option_c': 'Responsorial Psalm',
      'option_d': 'Second Reading',
      'correct_option': 'b',
      'explanation':
          'Ang First Reading ay karaniwang mula sa Lumang Tipan at binabasa bago ang Responsorial Psalm.',
      'season': null,
      'difficulty': 'easy',
    });
    await db.insert('trivia_questions', {
      'question':
          'Ilang araw ang tinatawag na "Triduum Pasko ng Muling Pagkabuhay"?',
      'option_a': '2 araw',
      'option_b': '3 araw',
      'option_c': '4 araw',
      'option_d': '7 araw',
      'correct_option': 'b',
      'explanation':
          'Ang Easter Triduum ay binubuo ng Huwebes Santo, Biyernes Santo, at Sabado de Gloria.',
      'season': 'easter',
      'difficulty': 'medium',
    });
    await db.insert('trivia_questions', {
      'question': 'Anong simbolo ang kinakatawan ng kandila sa Simbahan?',
      'option_a': 'Kamatayang ni Hesus',
      'option_b': 'Si Maria',
      'option_c': 'Si Hesus bilang Liwanag ng Mundo',
      'option_d': 'Ang Espiritu Santo',
      'correct_option': 'c',
      'explanation':
          'Ang kandila ay simbolo ni Hesukristo bilang Liwanag ng Mundo ayon sa Ebanghelyo ni Juan.',
      'season': null,
      'difficulty': 'easy',
    });
    await db.insert('trivia_questions', {
      'question':
          'Ano ang tinatawag sa pagbabago ng tinapay at alak sa katawan at dugo ni Kristo?',
      'option_a': 'Transubstantiation',
      'option_b': 'Consecration',
      'option_c': 'Benediction',
      'option_d': 'Communion',
      'correct_option': 'a',
      'explanation':
          'Ang Transubstantiation ay ang tawag sa misteryong pagbabago ng tinapay at alak sa tunay na Katawan at Dugo ni Kristo.',
      'season': null,
      'difficulty': 'hard',
    });
  }

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
