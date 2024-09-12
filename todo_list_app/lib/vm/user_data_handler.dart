import 'package:sqflite/sqflite.dart';
import 'package:todo_list_app/model/user.dart';
import 'package:todo_list_app/vm/database_handler.dart';

class UserDataHandler {
  DatabaseHandler handler = DatabaseHandler();

  // 로그인
  Future<List<dynamic>> checkUser(String id, String pw) async {
    final Database db = await handler.initializeDB();
    int idCheck = 0;
    dynamic idSeq = 0;
    final List<Map<String, Object?>> queryResult = await db.rawQuery("""
        SELECT
            seq, count(id) as id 
        FROM 
            user 
        WHERE
            id = ? and pw = ?
    """, [id, pw]);

    queryResult.map(
      (e) {
        Map<String, dynamic> res = e;
        idCheck = res['id'];
        idSeq = res['seq'];
      },
    ).toList();
    // [0, 1] 에러, [1, 1] 정상
    return [idCheck, idSeq];
  }

  // 회원가입
  Future<int> insertUser(User user) async {
    final Database db = await handler.initializeDB();

    final int queryResult = await db.rawInsert("""
    INSERT INTO user(id, pw, name)
    VALUES (?, ?, ?)
    """, [user.id, user.pw, user.name]);

    return queryResult;
  }

  // // 회원 가입시 투두리스트 추가를 위한 seq가져오기
  // Future<void> selectSeq(String id) async {
  //   final Database db = await handler.initializeDB();
  //   int seqNum = 0;
  //   final List<Map<String, Object?>> seq = await db.rawQuery("""
  //   SELECT seq
  //   FROM user
  //   WHERE id = ?
  //   """, [id]);

  //   seq.map(
  //     (e) {
  //       Map<String, dynamic> res = e;
  //       seqNum = res['id'];
  //     },
  //   ).toList();

  //   insertInitTodolist(seq);
  // }

  // // 회원 가입시 기본 투두리스트 데이터 (설명)
  // Future<int> insertInitTodolist(seq) async {
  //   final Database db = await handler.initializeDB();
  //   // user_seq추가
  //   final int queryResult = await db.rawInsert("""
  //   INSERT INTO todolist(user_seq, todoid, tododate, task, category, state, isdelete)
  //   VALUES (?, ?, ?, ?, ?, ?, ?)
  //   """, [seq, "투두아이디", "9999-12-31", "설명", "설명", "미완료", "안버림"]);

  //   return queryResult;
  // }

  // 회원가입 아이디 중복 확인
  Future<int> signUpCheckUser(String id) async {
    final Database db = await handler.initializeDB();
    int idCheck = 0;
    final List<Map<String, Object?>> queryResult = await db.rawQuery("""
        SELECT
            count(id) as id 
        FROM 
            user 
        WHERE
            id = ?
    """, [id]);

    queryResult.map(
      (e) {
        Map<String, dynamic> res = e;
        idCheck = res['id'];
      },
    ).toList();
    // [0, 1] 에러, [1, 1] 정상
    return idCheck;
  }
}
