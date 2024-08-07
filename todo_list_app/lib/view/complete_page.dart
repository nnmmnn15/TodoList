import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/model/user_list.dart';

class CompletePage extends StatefulWidget {
  const CompletePage({super.key});

  @override
  State<CompletePage> createState() => _CompletePageState();
}

class _CompletePageState extends State<CompletePage> {
  var userIndex = Get.arguments ?? 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: ListView.builder(
            itemCount: UserList.todoDataList[userIndex].todoList.length,
            itemBuilder: (context, index) {
              return UserList.todoDataList[userIndex].todoList[index].todoState
                  ? Dismissible(
                      key: ValueKey(
                          UserList.todoDataList[userIndex].todoList[index]),
                      direction: DismissDirection.endToStart,
                      background: Container(
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
                      onDismissed: (direction) {
                        // 삭제 리스트에 추가
                        UserList.todoDataList[userIndex].deleteList.add(
                            UserList.todoDataList[userIndex].todoList[index]);
                        // 투두리스트에서 제거
                        UserList.todoDataList[userIndex].todoList.remove(
                            UserList.todoDataList[userIndex].todoList[index]);
                        setState(() {});
                      },
                      // 데이터 보여지는곳
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        // 할일 완료 제스쳐
                        child: GestureDetector(
                          onDoubleTap: () {
                            UserList.todoDataList[userIndex].todoList[index]
                                    .todoState =
                                !UserList.todoDataList[userIndex].todoList[index]
                                    .todoState;
                            setState(() {});
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.black, width: 1))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: SizedBox(
                                height: 50,
                                child: Center(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 40,
                                        child: Text(UserList
                                            .todoDataList[userIndex]
                                            .todoList[index]
                                            .categorySet
                                            .categoryName),
                                      ),
                                      Container(
                                        width: 10,
                                        color: UserList
                                            .todoDataList[userIndex]
                                            .todoList[index]
                                            .categorySet
                                            .categoryColor,
                                      ),
                                      Text(
                                        UserList.todoDataList[userIndex]
                                            .todoList[index].todoText,
                                        style: TextStyle(
                                          decoration: UserList
                                                  .todoDataList[userIndex]
                                                  .todoList[index]
                                                  .todoState
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
                      ),
                    )
                  // 할일이 완료되지 않은 값을 받았을때 빈 박스
                  : const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

}
