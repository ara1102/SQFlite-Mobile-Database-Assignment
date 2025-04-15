import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_mobile_database_assignment/contact.dart';

const String fileName = "contacts_database_db";

class AppDatabase{
  AppDatabase._init();

  static final AppDatabase instance = AppDatabase._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDB(fileName);
    return _database!;
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        $idField $idType,
        $nameField $textType,
        $contactField $textType
      )
    ''');

  }
  Future<Database> _initializeDB(String fileName) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<Contact> createContact(Contact contact) async{
    final db = await instance.database;
    final id = await db.insert(tableName, contact.toJson());
    return contact.copyWith(id: id);
  }

  Future<List<Contact>> readAllContact() async {
    final db = await instance.database;
    final result = await db.query(tableName);
    return result.map((json)=> Contact.fromJson(json)).toList();
  }

  Future<void> close() async {
    final db = await instance.database;
    return db.close();
  }

  Future<int> updateContact(Contact contact) async {
    final db = await instance.database;
    return db.update(
      tableName,
      contact.toJson(),
      where: "$idField = ?",
      whereArgs: [contact.id],
    );
  }

  Future<int> deleteContact(Contact contact) async {
    final db = await instance.database;
    return await db.delete(
      tableName,
      where: "$idField = ?",
      whereArgs: [contact.id],
    );
  }


}
