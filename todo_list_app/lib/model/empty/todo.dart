import 'package:todo_list_app/model/empty/category_set.dart';

class Todo {
  String todoText;
  CategorySet categorySet;
  bool todoState;
  DateTime deadline;

  Todo(
      {required this.todoText,
      required this.categorySet,
      required this.todoState,
      required this.deadline});
}
