import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'networking.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE lessons (
        lesson_id INTEGER PRIMARY KEY AUTOINCREMENT,
        lesson_name TEXT
    )
    ''');
    await db.execute('''
    CREATE TABLE tests (
        test_id INTEGER PRIMARY KEY AUTOINCREMENT,
        lesson_id INTEGER,
        test_name TEXT,
        FOREIGN KEY (lesson_id) REFERENCES lessons (lesson_id)
    )
    ''');
    await db.execute('''
    CREATE TABLE questions (
        question_id INTEGER PRIMARY KEY AUTOINCREMENT,
        test_id INTEGER,
        question_text TEXT,
        choice1 TEXT,
        choice2 TEXT,
        choice3 TEXT,
        choice4 TEXT,
        correct_choice INTEGER,
        state INTEGER DEFAULT 0,
        FOREIGN KEY (test_id) REFERENCES tests (test_id)
    )
    ''');

    // Prepopulate the database with initial data
    await db.insert('lessons', {'lesson_name': 'Lesson 1'});
    await db.insert('tests', {'lesson_id': 1, 'test_name': 'Test 1'});
    await db.insert('questions', {
      'test_id': 1,
      'question_text': 'What is networking?',
      'choice1': 'Option 1',
      'choice2': 'Option 2',
      'choice3': 'Option 3',
      'choice4': 'Option 4',
      'correct_choice': 1
    });
  }

  // Define methods to retrieve data from the database
  Future<List<Map<String, dynamic>>> getTests() async {
    Database db = await database;
    return await db.query('tests');
  }

  Future<List<Map<String, dynamic>>> getQuestions(int testId) async {
    Database db = await database;
    return await db.query(
      'questions',
      where: 'test_id = ?',
      whereArgs: [testId],
      orderBy: 'state ASC',
    );
  }
}
