import 'package:todo_list_app/model/todo.dart';

class UserData{
  List<Todo> todoList =[];
  List<Todo> completeList =[];
  List<Todo> deleteList =[];

  UserData.init();

  UserData(List<Todo> todo, List<Todo> complete, List<Todo> delete){
    todoList = todo;
    completeList = complete;
    deleteList = delete;
  }
}