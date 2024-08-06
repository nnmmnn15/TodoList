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
      appBar: AppBar(
        title: const Text('완료한 할일 목록'),
      ),
      body: Center(
        child: SizedBox(
          width: 340,
          // 리스트뷰 빌더
          child: ListView.builder(
            // 유저의 리스트 중 완료리스트의 길이
            itemCount: UserList.todoDataList[userIndex].completeList.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.amber[50],
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    height: 50,
                    child: Center(
                      child: Row(
                        children: [
                          Checkbox(
                            value: UserList.todoDataList[userIndex]
                                .completeList[index].todoState,
                            onChanged: (value) {
                              UserList.todoDataList[userIndex]
                                  .completeList[index].todoState = value!;
                              if (UserList.todoDataList[userIndex]
                                      .completeList[index].todoState ==
                                  false) {
                                // 투두리스트에 추가
                                UserList.todoDataList[userIndex].todoList.add(
                                    UserList.todoDataList[userIndex]
                                        .completeList[index]);
                                // 완료리스트에서 제거
                                UserList.todoDataList[userIndex].completeList
                                    .remove(UserList.todoDataList[userIndex]
                                        .completeList[index]);
                              }
                              setState(() {});
                            },
                          ),
                          Text(
                            UserList.todoDataList[userIndex].completeList[index]
                                .todoText,
                          ),
                        ],
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
