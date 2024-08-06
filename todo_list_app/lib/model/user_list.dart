import 'package:todo_list_app/model/todo.dart';
import 'package:todo_list_app/model/user_data.dart';

class UserList {
  static List<String> userIdList = ['root'];
  static List<String> userPwList = ['1234'];
  static List<UserData> todoDataList = [
    UserData(
      // todolist
      [
        Todo(todoText: '달리기', todoState: false),
        Todo(todoText: '병원가기', todoState: false),
        Todo(todoText: '축구', todoState: false),
        Todo(todoText: '약속', todoState: false),
        Todo(todoText: '약속', todoState: false),
        Todo(todoText: '약속', todoState: false),
        Todo(todoText: '약속', todoState: false),
        Todo(todoText: '약속', todoState: false),
        Todo(todoText: '약속', todoState: false),
        Todo(todoText: '약속', todoState: false),
        Todo(todoText: '약속', todoState: false),
        Todo(todoText: '약속', todoState: false),
        Todo(todoText: '약속', todoState: false),
        Todo(todoText: '약속', todoState: false),
        Todo(todoText: '약속', todoState: false),
        Todo(todoText: '약속', todoState: false),
        Todo(todoText: '약속', todoState: false),
        Todo(todoText: '약속', todoState: false),
      ],
      // completelist
      [],
      // deletelist
      [],
    ),
  ];
}
