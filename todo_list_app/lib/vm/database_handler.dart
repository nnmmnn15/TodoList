import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      // 경로에 db파일이 있는지 확인
      join(path, 'todoapp.db'),
      // DB가 존재하지 않을 때 생성
      onCreate: (db, version) async {
        await db.execute("""
          create table user (
            seq integer primary key autoincrement,
            id text,
            pw text,
            name text,
            profile blob)
        """);
        await db.execute("""
          create table category (
            user_seq integer,
            name text,
            color text,
            primary key(user_seq, name))
        """);
        await db.execute("""
          create table todolist (
            todoid integer primary key autoincrement,
            user_seq integer,
            tododate text,
            task text,
            category text,
            state text,
            isdelete text,
            deletedate text)
        """); // 삭제일자 추가 할지?
      },
      version: 1,
    );
  }
}
