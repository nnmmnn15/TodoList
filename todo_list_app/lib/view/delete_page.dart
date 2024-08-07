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
      backgroundColor: Colors.amber[100],
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: UserList.todoDataList[userIndex].deleteList.isEmpty ? 
          const Text('삭제된 일이 없습니다'):
          ListView.builder(
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.black, width: 1))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        height: 50,
                        child: Center(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 40,
                                child: Text(UserList.todoDataList[userIndex]
                                    .deleteList[index].categorySet.categoryName),
                              ),
                              Container(
                                width: 10,
                                color: UserList.todoDataList[userIndex]
                                    .deleteList[index].categorySet.categoryColor,
                              ),
                              Text(
                                UserList.todoDataList[userIndex].deleteList[index]
                                    .todoText,
                                style: TextStyle(
                                  decoration: UserList.todoDataList[userIndex]
                                          .deleteList[index].todoState
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  decorationThickness: 2,
                                ),
                              ),
                            ],
                          ),
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
