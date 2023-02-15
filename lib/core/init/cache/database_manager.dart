import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

import '../../constants/cache/db_tables_enum.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._init();
  static DatabaseManager get instance => _instance;

  DatabaseManager._init();

  String? _dbPath;

  static Future databaseInit() async {
    _instance._dbPath = await sql.getDatabasesPath();
  }

  Future<sql.Database> database(DBTablesEnum table) async {
    return sql.openDatabase(
      path.join(_dbPath!, '${table.value}.db'),
      onCreate: (db, version) {
        return db.execute(table.createTableQuery);
      },
      version: 1,
    );
  }

  Future<void> insert(DBTablesEnum table, Map<String, dynamic> data) async {
    final sqlDb = await database(table);
    await sqlDb.insert(table.value, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getData(DBTablesEnum table) async {
    final sqlDb = await database(table);
    return sqlDb.query(table.value);
  }
}
