import 'package:flutter/material.dart';
import 'package:todo_list_app/model/category_set.dart';
import 'package:todo_list_app/model/todo.dart';
import 'package:todo_list_app/model/user_data.dart';

class UserList {
  static List<String> userIdList = ['root'];
  static List<String> userPwList = ['1234'];
  static List<UserData> todoDataList = [
    UserData(
      // todolist
      [
        Todo(todoText: '달리기', categorySet: CategorySet(categoryColor: Colors.deepPurple[100]!, categoryName: '심부름') , todoState: false, deadline: DateTime(2004, 08, 08)),
        Todo(todoText: '병원가기', categorySet: CategorySet(categoryColor: Colors.blue[100]!, categoryName: '약속'), todoState: false, deadline: DateTime(2024, 08, 08)),
        Todo(todoText: '축구', categorySet: CategorySet(categoryColor: Colors.green[100]!, categoryName: '일상'), todoState: false, deadline: DateTime(2024, 08, 08)),
        Todo(todoText: '약속', categorySet: CategorySet(categoryColor: Colors.red[100]!, categoryName: '중요일정'), todoState: false, deadline: DateTime(2024, 08, 08)),
      ],
      // deletelist
      [],
    ),
  ];
}
