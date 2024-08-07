import 'package:todo_list_app/model/category_set.dart';

class Todo{
  String todoText;
  CategorySet categorySet;
  bool todoState;

  Todo({required this.todoText, required this.categorySet, required this.todoState});
}