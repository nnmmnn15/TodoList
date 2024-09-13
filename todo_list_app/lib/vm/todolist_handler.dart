import 'package:get_storage/get_storage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list_app/model/task.dart';
import 'package:todo_list_app/vm/database_handler.dart';

class TodolistHandler {
  GetStorage box = GetStorage();
  DatabaseHandler handler = DatabaseHandler();

  Future<List<Task>> queryTask() async {
    final Database db = await handler.initializeDB();
    final List<Map<String, Object?>> queryResults = await db.rawQuery("""
        SELECT *
        FROM 
          todolist, category
        WHERE 
          todolist.user_seq = ? AND category.user_seq =? AND
          category.name = todolist.category AND
          isdelete = "안버림"      
      """, [box.read('nmcTodoUserSeq'), box.read('nmcTodoUserSeq')]);
    return queryResults.map((e) => Task.fromMap(e)).toList();
  }

  Future<int> updateTodolistState(int todoId, String state) async {
    state = state == "완료" ? "미완료" : "완료";
    final Database db = await handler.initializeDB();
    final updateResults = await db.rawUpdate("""
        UPDATE todolist
        SET state = ?
        WHERE todoid = ? 
    """, [state, todoId]);

    return updateResults;
  }

  Future<int> updateTodolistDelete(int todoId, String delete) async {
    delete = delete == "안버림" ? "버림" : "안버림";
    final Database db = await handler.initializeDB();
    final updateResults = await db.rawUpdate("""
        UPDATE todolist
        SET isdelete = ?
        WHERE todoid = ?
    """, [delete, todoId]);

    return updateResults;
  }

  Future<List<Task>> queryDeleteTask() async {
    final Database db = await handler.initializeDB();
    final List<Map<String, Object?>> queryResults = await db.rawQuery("""
        SELECT *
        FROM 
          todolist, category
        WHERE 
          todolist.user_seq = ? AND category.user_seq =? AND
          category.name = todolist.category AND
          isdelete = "버림"      
      """, [box.read('nmcTodoUserSeq'), box.read('nmcTodoUserSeq')]);
    return queryResults.map((e) => Task.fromMap(e)).toList();
  }

  Future<List<Task>> queryCompleteTask() async {
    final Database db = await handler.initializeDB();
    final List<Map<String, Object?>> queryResults = await db.rawQuery("""
        SELECT *
        FROM 
          todolist, category
        WHERE 
          todolist.user_seq = ? AND category.user_seq =? AND
          category.name = todolist.category AND
          isdelete = "안버림" AND
          state = "완료"
      """, [box.read('nmcTodoUserSeq'), box.read('nmcTodoUserSeq')]);
    return queryResults.map((e) => Task.fromMap(e)).toList();
  }
}
