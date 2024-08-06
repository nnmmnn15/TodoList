import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/model/user_list.dart';

class DeletePage extends StatefulWidget {
  const DeletePage({super.key});

  @override
  State<DeletePage> createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  var userIndex = Get.arguments ?? 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('휴지통'),
        centerTitle: false,
      ),
      body: Center(
        child: SizedBox(
          width: 340,
          // 리스트뷰 빌더
          child: ListView.builder(
            // 유저의 리스트 중 투두리스트의 길이
            itemCount: UserList.todoDataList[userIndex].deleteList.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: ValueKey(
                    UserList.todoDataList[userIndex].deleteList[index]),
                direction: DismissDirection.horizontal,
                background: Container(
                  color: Colors.blue,
                  alignment: Alignment.centerRight,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
                // 삭제전에 다이얼로그 구현, (미구현)
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    // 삭제리스트에서 제거 (완전제거)
                    UserList.todoDataList[userIndex].deleteList.remove(
                        UserList.todoDataList[userIndex].deleteList[index]);
                  } else {
                    UserList.todoDataList[userIndex].todoList.add(
                        UserList.todoDataList[userIndex].deleteList[index]);
                    // 삭제 리스트에서 제거
                    UserList.todoDataList[userIndex].deleteList.remove(
                        UserList.todoDataList[userIndex].deleteList[index]);
                  }
                  setState(() {});
                },
                child: Card(
                  color: Colors.amber[50],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      height: 50,
                      child: Center(
                        child: Row(
                          children: [
                            Text(
                              UserList.todoDataList[userIndex].deleteList[index]
                                  .todoText,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
