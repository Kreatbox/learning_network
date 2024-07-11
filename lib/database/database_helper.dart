import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  static Database? _database;

  // دالة للحصول على قاعدة البيانات
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // دالة لتهيئة قاعدة البيانات
  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      var factory = databaseFactoryFfiWeb;
      var db = await factory.openDatabase('networking.db');
      await _checkAndCreateTables(db);
      return db;
    } else {
      String path = join(await getDatabasesPath(), 'networking.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      );
    }
  }

  // دالة للتحقق من وجود الجداول وإنشائها إذا لم تكن موجودة
  Future<void> _checkAndCreateTables(Database db) async {
    var result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='tests'");
    if (result.isEmpty) {
      await _onCreate(db, 1);
    }
  }

  // دالة لإنشاء الجداول عند تهيئة قاعدة البيانات
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE lessons (
        lesson_id INTEGER PRIMARY KEY AUTOINCREMENT,
        lesson_name TEXT,
        lesson_first_title TEXT,
        lesson_first_content TEXT,
        lesson_second_title TEXT,
        lesson_second_content TEXT,
        lesson_third_title TEXT,
        lesson_third_content TEXT,
        lesson_link TEXT
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

    // إدراج بيانات عينة للدروس، الاختبارات، والأسئلة
    await db.insert('lessons', {
      'lesson_name': 'الدرس الأول',
      'lesson_first_title': 'النياسب',
      'lesson_first_content':
          'حكي عن النياسب لانو النياسب ظرييفة ما هيك الدرس شي ظريف وحلو وبيفيد الصحة لهيك الكل لازم يدرس متل الشاطر',
      'lesson_second_title': 'أهمية النياسب',
      'lesson_second_content': 'مهمة كتير',
      'lesson_third_title': 'ترتيب العمل',
      'lesson_third_content': 'واحد بعدين 2 بعدين تالتة',
      'lesson_link': 'https://www.youtube.com/watch?v=9ANSu9Cg-Bo'
    });
    await db.insert('lessons', {
      'lesson_name': 'الدرس الثاني',
      'lesson_first_title': 'السيمافور',
      'lesson_first_content':
          'حكي عن السمافور لانو السيمافور ظريف ما هيك الدرس شي ظريف وحلو وبيفيد الصحة لهيك الكل لازم يدرس متل الشاطر',
      'lesson_second_title': 'شبعرفني',
      'lesson_second_content': 'هي مثال كرمال نفهم شلون نشتغل',
      'lesson_third_title': 'هي بدنا نحولها sql ونقعد نعبيها متل الحبابين',
      'lesson_third_content': 'تماما متل العنوان >3',
      'lesson_link': 'https://www.youtube.com/watch?v=9ANSu9Cg-Bo'
    });
    await db
        .insert('tests', {'lesson_id': 1, 'test_name': 'إختبار الدرس الأول'});
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

  // دالة لجلب الاختبارات
  Future<List<Map<String, dynamic>>> getTests() async {
    Database db = await database;
    return await db.query('tests');
  }

  // دالة لجلب الأسئلة بناءً على معرف الاختبار مرتبة حسب الحالة
  Future<List<Map<String, dynamic>>> getQuestions(int testId) async {
    Database db = await database;
    return await db.query(
      'questions',
      where: 'test_id = ?',
      whereArgs: [testId],
      orderBy: 'state ASC',
    );
  }

  // دالة لتحديث حالة السؤال بناءً على معرفه
  Future<void> updateQuestionState(int questionId, int newState) async {
    Database db = await database;
    await db.update(
      'questions',
      {'state': newState},
      where: 'question_id = ?',
      whereArgs: [questionId],
    );
  }

  // دالة لجلب الدروس
  Future<List<Map<String, dynamic>>> getLessons() async {
    Database db = await database;
    return await db.query('lessons');
  }

  // دالة لجلب الدرس بناءً على معرف الدرس
  Future<Map<String, dynamic>?> getLessonById(int lessonId) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'lessons',
      where: 'lesson_id = ?',
      whereArgs: [lessonId],
    );
    return result.isNotEmpty ? result.first : null;
  }
}
