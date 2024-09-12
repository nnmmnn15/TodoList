// 데이터를 읽어올때
class Task {
  int? userSeq;
  String todoid;
  String tododate;
  String task;
  String category;
  String state;
  String isdelete;
  String deletedate;
  String color;

  Task(
      {this.userSeq,
      required this.todoid,
      required this.tododate,
      required this.task,
      required this.category,
      required this.state,
      required this.isdelete,
      required this.deletedate,
      required this.color});

  Task.fromMap(Map<String, dynamic> res)
      : userSeq = res['user_seq'],
        todoid = res['todoid'],
        tododate = res['tododate'],
        task = res['task'],
        category = res['category'],
        state = res['state'],
        isdelete = res['isdelete'],
        deletedate = res['deletedate'],
        color = res['color'];
}
