enum DBTablesEnum { places }

extension DBTablesEnumExtension on DBTablesEnum {
  String get value {
    switch (this) {
      case DBTablesEnum.places:
        return 'user_places';
    }
  }

  String get createTableQuery {
    switch (this) {
      case DBTablesEnum.places:
        return 'CREATE TABLE $value(id TEXT PRIMARY KEY, title TEXT, image TEXT, loc_lat REAL, loc_lng REAL, address TEXT)';
    }
  }
}
