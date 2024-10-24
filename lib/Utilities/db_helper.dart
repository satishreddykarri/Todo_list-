import 'dart:io';
import 'package:path/path.dart'; // Import for join function
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/Models/todo_model.dart';

class DataBaseHelper {
  String tablename = "to_do_list_table";
  String id = "id";
  String title = "title";
  String description = "description";
  String status = "status";
  String date = "date";

  static DataBaseHelper? _dataBaseHelper;
  DataBaseHelper._createInstance();

  factory DataBaseHelper() {
    _dataBaseHelper ??= DataBaseHelper._createInstance();
    return _dataBaseHelper!;
  }

  Database? _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "my_to_list_database.db");
    return await openDatabase(path, version: 1, onCreate: _create);
  }

  Future<void> _create(Database database, int version) async {
    await database.execute(
        "CREATE TABLE $tablename ($id INTEGER PRIMARY KEY AUTOINCREMENT, $title VARCHAR(100), $description VARCHAR(100), $status VARCHAR(100), $date VARCHAR(100))");
  }

  Future<int> insert(TodoModel todoModel) async {
    Database db = await this.database;
    var result = await db.insert(tablename, todoModel.toMap());
    print("Data inserted");
    return result;
  }

  Future<List<Map<String, dynamic>>> getDatainMaps() async {
    Database db = await this.database;
    return await db.query(tablename);
  }

  Future<List<TodoModel>> getModelsFromMapList() async {
    List<Map<String, dynamic>> mapList = await getDatainMaps();
    List<TodoModel> toDoListModel = [];
    for (var map in mapList) {
      toDoListModel.add(TodoModel.fromMap(map));
    }
    return toDoListModel;
  }

  Future<int> updateItem(TodoModel todoModel) async {
    Database database = await this.database;
    return await database.update(tablename, todoModel.toMap(),
        where: "$id = ?", whereArgs: [todoModel.id] // Wrap id in a list
        );
  }

  Future<int> deleteItem(TodoModel todoModel) async {
  Database database = await this.database;
  return await database.delete(tablename, where: "$id = ?", whereArgs: [todoModel.id]);
}
}
