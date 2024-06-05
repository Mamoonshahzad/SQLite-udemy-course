import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import '../model/dish_model.dart';

class DbHelper {
  late Database _db;
  Completer<Database>? _dbOpenCompleter;

  Future<void> initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'dishesDb.db');

    Database db = await openDatabase(path, version: 1, onCreate: onCreate);

    // Complete the completer with the database instance
    _dbOpenCompleter!.complete(db);
  }

  void onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Dishes(name TEXT PRIMARY KEY, description TEXT, price DOUBLE)");
  }

  Future<Database> get db async {
    // If the completer is null, db is not initialized
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      await initDb();
    }
    // Return the future associated with the completer
    return _dbOpenCompleter!.future;
  }

  // Create Data
  Future<int> createDish(Dish dish) async {
    var dbReady = await db;
    return await dbReady.rawInsert(
        "INSERT INTO Dishes(name, description, price) VALUES ('${dish.name}', '${dish.description}', '${dish.price}')");
  }

  // Update Data
  Future<int> updateDish(Dish dish) async {
    var dbReady = await db;
    return await dbReady.rawUpdate(
        "UPDATE Dishes SET description = '${dish.description}', price = '${dish.price}' WHERE name = '${dish.name}'");
  }

  // Delete data
  Future<int> deleteDish(String name) async {
    var dbReady = await db;
    return await dbReady.rawDelete("DELETE FROM Dishes WHERE name = '$name'");
  }

  // Read Data
  Future<Dish> readDish(String name) async {
    var dbReady = await db;
    var read =
        await dbReady.rawQuery("SELECT * FROM Dishes WHERE name = '$name'");

    if (read.isNotEmpty) {
      return Dish.fromMap(read[0]);
    } else {
      throw Exception('Dish not found');
    }
  }

  //Read All Data
  Future<List<Dish>> readAllDishes() async {
    var dbReady = await db;
    List<Map> list = await dbReady.rawQuery("SELECT * FROM Dishes");
    List<Dish> dishes = [];
    for (int i = 0; i < list.length; i++) {
      dishes
          .add(Dish(list[i]["name"], list[i]["description"], list[i]["price"]));
    }
    return dishes;
  }
}
