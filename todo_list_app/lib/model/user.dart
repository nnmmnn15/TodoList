import 'dart:typed_data';

class User {
  int? seq;
  String id;
  String pw;
  String name;
  Uint8List? image;

  User({
    required this.id,
    required this.pw,
    required this.name,
  });

  User.fromMap(Map<String, dynamic> res)
      : seq = res['seq'],
        id = res['id'],
        pw = res['pw'],
        name = res['name'],
        image = res['image'];
}
