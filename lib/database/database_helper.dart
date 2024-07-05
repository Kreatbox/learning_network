// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
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

    await db.insert('lessons', {'lesson_name': 'الدرس الأول'});
    await db
        .insert('tests', {'lesson_id': 1, 'test_name': 'إختبار الدرس الأول'});
    await db.insert('lessons', {'lesson_name': 'الدرس الثاني'});
    await db
        .insert('tests', {'lesson_id': 2, 'test_name': 'إختبار الدرس الثاني'});
    await db.insert('questions', {
      'test_id': 1,
      'question_text': ':الحالة الاولى في دورة حياة النيسب هي',
      'choice1': 'عدم الانطلاق',
      'choice2': 'الانطلاق',
      'choice3': 'التوقف الأول',
      'choice4': 'التعليق',
      'correct_choice': 1
    });
    await db.insert('questions', {
      'test_id': 1,
      'question_text': ':يدخل النيسب في حالة الإيقاف أو الإحباط عند',
      'choice1': 'انهاء المهام بشكل طبيعي',
      'choice2': 'انهاء المهام بشكل مجبر',
      'choice3': 'عند العجز على  استخدام أي معالج',
      'choice4': 'الجواب 1 و 2',
      'correct_choice': 4
    });
    await db.insert('questions', {
      'test_id': 2,
      'question_text': ':من خواص الإتصال المرتبط',
      'choice1': 'ممكن أن تضيع الرساالة المرسلة',
      'choice2': 'يشابه الخدمة البريدية',
      'choice3': 'قابل لإرسال رسالتين في مسارين مختلفين',
      'choice4': 'يغلق عند ينتهي الاتصال من أحد الطرفين',
      'correct_choice': 4
    });
  }

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

// here if we add sql file instead 

// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'package:flutter/services.dart';
// import 'dart:io';

// class DatabaseHelper {
//   static final DatabaseHelper _instance = DatabaseHelper._internal();

//   factory DatabaseHelper() {
//     return _instance;
//   }

//   DatabaseHelper._internal();

//   static Database? _database;

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     String databasesPath = await getDatabasesPath();
//     String path = join(databasesPath, 'networking.db');

//     // Check if the database already exists
//     bool dbExists = await databaseExists(path);

//     if (!dbExists) {
//       // Copy from assets
//       try {
//         await Directory(dirname(path)).create(recursive: true);
//       } catch (_) {}
//       ByteData data = await rootBundle.load(join('assets', 'networking.db'));
//       List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//       await File(path).writeAsBytes(bytes, flush: true);
//     }

//     return await openDatabase(path);
//   }

//   Future<List<Map<String, dynamic>>> getTests() async {
//     Database db = await database;
//     return await db.query('tests');
//   }

//   Future<List<Map<String, dynamic>>> getQuestions(int testId) async {
//     Database db = await database;
//     return await db.query(
//       'questions',
//       where: 'test_id = ?',
//       whereArgs: [testId],
//       orderBy: 'state ASC',
//     );
//   }
// }
