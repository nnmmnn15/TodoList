import 'package:get_storage/get_storage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list_app/model/task.dart';
import 'package:todo_list_app/model/todolist.dart';
import 'package:todo_list_app/vm/database_handler.dart';

class TodolistHandler {
  GetStorage box = GetStorage();
  DatabaseHandler handler = DatabaseHandler();

  // 할일 정보가져오기
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
        ORDER BY
          tododate desc
      """, [box.read('nmcTodoUserSeq'), box.read('nmcTodoUserSeq')]);
    return queryResults.map((e) => Task.fromMap(e)).toList();
  }

  // 할일 추가하기
  Future insertTask(Todolist todolist) async {
    final db = await handler.initializeDB();
    int result = await db.rawInsert("""
        INSERT INTO
          todolist(user_seq, tododate, task, category, state, isdelete)
        VALUES
          (?, ?, ?, ?, ?, ?)
    """, [
      todolist.userSeq,
      todolist.tododate,
      todolist.task,
      todolist.category,
      todolist.state,
      todolist.isdelete
    ]);

    return result;
  }

  // 할일 수정하기
  Future updateTask(Todolist todolist) async {
    final db = await handler.initializeDB();
    int result = await db.rawUpdate("""
        UPDATE todolist 
        SET
          tododate = ?, 
          task = ?, 
          category = ?
        WHERE
          todoid = ? AND user_seq = ?
    """, [
      todolist.tododate,
      todolist.task,
      todolist.category,
      todolist.todoid,
      todolist.userSeq
    ]);

    return result;
  }

  // 완료 미완료 업데이트
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

  // 버림 안버림 업데이트
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

  // 삭제목록 가져오기
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

  // 완료 목록 가져오기
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
