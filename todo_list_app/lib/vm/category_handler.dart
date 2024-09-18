import 'package:get_storage/get_storage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list_app/model/todo_category.dart';
import 'package:todo_list_app/vm/database_handler.dart';

class CategoryHandler {
  GetStorage box = GetStorage();
  DatabaseHandler handler = DatabaseHandler();

  // 카테고리 추가
  insertCategory(TodoCategory category) async {
    final Database db = await handler.initializeDB();
    final int queryResult = await db.rawInsert("""
    INSERT INTO category
    VALUES (?, ?, ?)
    """, [category.userSeq, category.name, category.color]);
    return queryResult;
  }

  // 카테고리 정보 가져오기
  Future<List<TodoCategory>> queryCategory() async {
    final Database db = await handler.initializeDB();
    final List<Map<String, Object?>> queryResults = await db.rawQuery("""
        SELECT *
        FROM 
          category
        WHERE 
          user_seq = ?
        ORDER BY
          name
      """, [box.read('nmcTodoUserSeq')]);
    return queryResults.map((e) => TodoCategory.fromMap(e)).toList();
  }
}
