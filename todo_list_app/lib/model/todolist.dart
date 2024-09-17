// 데이터를 추가할 때
class Todolist {
  int? userSeq;
  int? todoid;
  String tododate;
  String task;
  String category;
  String? state;
  String? isdelete;
  String? deletedate;

  Todolist({
    this.userSeq,
    this.todoid,
    required this.tododate,
    required this.task,
    required this.category,
    this.state,
    this.isdelete,
    this.deletedate,
  });

  Todolist.fromMap(Map<String, dynamic> res)
      : userSeq = res['user_seq'],
        todoid = res['todoid'],
        tododate = res['tododate'],
        task = res['task'],
        category = res['category'],
        state = res['state'],
        isdelete = res['isdelete'],
        deletedate = res['deletedate'];
}
