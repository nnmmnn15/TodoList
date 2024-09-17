class TodoCategory {
  int? userSeq;
  String name;
  String color;

  TodoCategory({
    this.userSeq,
    required this.name,
    required this.color,
  });

  TodoCategory.fromMap(Map<String, dynamic> res)
      : userSeq = res['user_seq'],
        name = res['name'],
        color = res['color'];
}
