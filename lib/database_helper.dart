import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'flashcard_model.dart'; // We need this to work with our Flashcard objects

class DatabaseHelper {
  // A private constructor. This class will only have static methods.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // A single, static instance of the Database.
  // The '?' means it can be null. We initialize it in the initDB method.
  static Database? _database;

  // A getter for our database. If it's not initialized, it will be.
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Lazily instantiate the db the first time it is accessed
    _database = await _initDB();
    return _database!;
  }

  // This opens the database (and creates it if it doesn't exist).
  _initDB() async {
    String path = join(await getDatabasesPath(), 'flashcard_database.db');
    return await openDatabase(
      path,
      version: 1,
      // This is called only when the database is created for the first time.
      onCreate: _onCreate,
    );
  }

  // SQL code to create the database table.
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE flashcards (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            question TEXT NOT NULL,
            answer TEXT NOT NULL
          )
          ''');
  }

  // ---- CRUD Operations ----

  // 1. CREATE: Insert a flashcard into the database
  Future<int> insertFlashcard(Flashcard card) async {
    Database db = await instance.database;
    // We pass the flashcard map to the insert method.
    // The toMap() method is in our flashcard_model.dart file.
    return await db.insert('flashcards', card.toMap());
  }

  // 2. READ: Get all flashcards from the database
  Future<List<Flashcard>> getFlashcards() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('flashcards');

    // Convert the List<Map<String, dynamic>> into a List<Flashcard>.
    return List.generate(maps.length, (i) {
      return Flashcard(
        id: maps[i]['id'],
        question: maps[i]['question'],
        answer: maps[i]['answer'],
      );
    });
  }

  // 3. UPDATE: Modify an existing flashcard
  Future<int> updateFlashcard(Flashcard card) async {
    Database db = await instance.database;
    // We update the flashcard that has the matching id.
    return await db.update(
      'flashcards',
      card.toMap(),
      where: 'id = ?',
      whereArgs: [card.id],
    );
  }

  // 4. DELETE: Remove a flashcard from the database
  Future<int> deleteFlashcard(int id) async {
    Database db = await instance.database;
    // We delete the flashcard that has the matching id.
    return await db.delete('flashcards', where: 'id = ?', whereArgs: [id]);
  }
}
