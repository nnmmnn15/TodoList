import 'package:todo_list_app/model/todo.dart';

class UserData{
  List<Todo> todoList =[];
  List<Todo> deleteList =[];

  UserData.init();

  UserData(List<Todo> todo, List<Todo> delete){
    todoList = todo;
    deleteList = delete;
  }
}