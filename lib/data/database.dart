import 'package:sqflite/sqflite.dart';
import 'package:todo/models/list_model.dart';
import 'package:todo/models/todo_model.dart';

class UserDatabaseProvider {
  final int _version = 3;
  Database? database;

  String toDoId = 'toDoId';
  String toDoTitle = 'title';
  String toDoText = 'text';
  String createdAt = 'createdAt';
  String schedule = 'schedule';
  String isImportant = 'isimportant';
  String isToday = 'istoday';
  String isDone = 'isdone';
  String tableName = 'tablename';
  String listid = 'listid';
  String listtitle = 'listtitle';
  String customcolor = 'customcolor';
  String primarycolor = 'primarycolor';
  String emoji = 'emoji';

  Future<void> initialize() async {
    final path = await getDatabasesPath();
    database = await openDatabase('$path/zortt.db', version: _version,
        onCreate: (db, version) {
      db.execute(
        'CREATE TABLE IF NOT EXISTS ToDo (id INTEGER PRIMARY KEY, $toDoId INTEGER, $toDoTitle TEXT, $toDoText  TEXT, $schedule TEXT, $createdAt TEXT, $isImportant TEXT, $isToday TEXT, $isDone TEXT, $tableName TEXT)',
      );
      db.execute(
        'CREATE TABLE IF NOT EXISTS Lists (id INTEGER PRIMARY KEY, $listid INTEGER, $listtitle TEXT, $customcolor INTEGER, $primarycolor INTEGER, $emoji TEXT)',
      );
    });
  }

  void createTable(String newTableName) async {
    if (database == null) {
      await initialize();
    }
    database!.execute(
      'CREATE TABLE IF NOT EXISTS $newTableName (id INTEGER PRIMARY KEY, $toDoId INTEGER, $toDoTitle TEXT, $toDoText  TEXT, $schedule TEXT, $createdAt TEXT, $isImportant TEXT, $isToday TEXT, $isDone TEXT, $tableName TEXT)',
    );
  }

  void deleteTable(String tablename) async {
    if (database == null) {
      await initialize();
    }
    try {
      database!.execute(
        'DROP TABLE IF EXISTS $tablename',
      );
    } catch (e) {
      print("database error : $e");
    }
  }

//* ToDO
  Future<List<ToDoModel>> getListOfModel(String tableName) async {
    if (database == null) {
      await initialize();
    }
    List<Map<String, dynamic>> userMaps = await database!.query(tableName);
    return userMaps.map((e) => ToDoModel.fromMap(e)).toList();
  }

  Future<List<ToDoModel>> getListScheduled(String tableName) async {
    if (database == null) {
      await initialize();
    }
    List<Map<String, dynamic>> userMaps = await database!.rawQuery(
        'SELECT * FROM $tableName WHERE schedule IS NOT NULL AND schedule != ""');
    return userMaps.map((e) => ToDoModel.fromMap(e)).toList();
  }

  Future<List<ToDoModel>> getListImportant(String tableName) async {
    if (database == null) {
      await initialize();
    }
    List<Map<String, dynamic>> userMaps = await database!
        .rawQuery('SELECT * FROM $tableName WHERE isimportant == "true"');
    return userMaps.map((e) => ToDoModel.fromMap(e)).toList();
  }

  Future<List<ToDoModel>> getListToday(String tableName) async {
    if (database == null) {
      await initialize();
    }
    List<Map<String, dynamic>> userMaps = await database!
        .rawQuery('SELECT * FROM $tableName WHERE istoday == "true"');
    return userMaps.map((e) => ToDoModel.fromMap(e)).toList();
  }

  Future<int> insert(ToDoModel toDoModel, String tableName) async {
    if (database == null) {
      await initialize();
    }
    Map<String, Object?> toDoMap = toDoModel.toMap();

    int id = await database!.insert(tableName, toDoMap);
    return id;
  }

  void delete(int id, String tableName) async {
    if (database == null) {
      await initialize();
    }

    database!.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  void deleteall(String tableName) async {
    if (database == null) {
      await initialize();
    }

    database!.delete(tableName);
  }

  Future<String> getTodayListLength(String tableName) async {
    if (database == null) {
      await initialize();
    }
    List<Map<String, dynamic>> userMaps = await database!
        .rawQuery('SELECT * FROM $tableName WHERE istoday == "true"');

    return userMaps.length.toString();
  }

  Future<String> getImportantListLength(String tableName) async {
    if (database == null) {
      await initialize();
    }
    List<Map<String, dynamic>> userMaps = await database!
        .rawQuery('SELECT * FROM $tableName WHERE isimportant == "true"');

    return userMaps.length.toString();
  }

  Future<String> getScheduledListLength(String tableName) async {
    if (database == null) {
      await initialize();
    }
    List<Map<String, dynamic>> userMaps = await database!.rawQuery(
        'SELECT * FROM $tableName WHERE schedule IS NOT NULL AND schedule != ""');

    return userMaps.length.toString();
  }

  Future<String> getAllListLength(String tableName) async {
    if (database == null) {
      await initialize();
    }
    List<Map<String, dynamic>> userMaps = await database!.query(tableName);

    return userMaps.length.toString();
  }

  void changeToDo(int id, ToDoModel newToDo, String tableName) async {
    if (database == null) {
      await initialize();
    }
    await database!.update(tableName, newToDo.toMap(),
        where: "id = ?", whereArgs: [newToDo.id]);
  }

//* ToDo

//* LİSTMODEL
  void insertList(
    ListModel listModel,
  ) async {
    if (database == null) {
      await initialize();
    }
    Map<String, Object?> listMap = listModel.toMap();

    database!.insert("Lists", listMap);
  }

  Future<List<ListModel>> getList() async {
    if (database == null) {
      await initialize();
    }
    List<Map<String, dynamic>> userMaps = await database!.query("Lists");
    return userMaps.map((e) => ListModel.fromMap(e)).toList();
  }

  Future<int> getListid() async {
    if (database == null) {
      await initialize();
    }
    List<Map<String, dynamic>> userMaps = await database!.query("Lists");
    return userMaps[0]["id"];
  }
//* LİSTMODEL

//* CUSTOMTODO

//* CUSTOMTODO
}
