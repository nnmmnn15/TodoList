import 'package:get_storage/get_storage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list_app/model/todolist.dart';
import 'package:todo_list_app/vm/database_handler.dart';

class TodolistHandler {
  GetStorage box = GetStorage();
  DatabaseHandler handler = DatabaseHandler();

  Future<List<Todolist>> queryStudents() async {
    final Database db = await handler.initializeDB();
    final List<Map<String, Object?>> queryResults = await db.rawQuery("""
        SELECT *
        FROM 
          todolist, category
        WHERE 
          todolist.user_seq = ? AND category.user_seq =?
          AND category.name = todolist.category
      """, [box.read('nmcTodoUserSeq'), box.read('nmcTodoUserSeq')]);
    return queryResults.map((e) => Todolist.fromMap(e)).toList();
  }
}
