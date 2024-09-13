import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/vm/todolist_handler.dart';

class DeletePage extends StatefulWidget {
  const DeletePage({super.key});

  @override
  State<DeletePage> createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  // var userIndex = Get.arguments ?? 0;
  late TodolistHandler handler;

  @override
  void initState() {
    super.initState();
    handler = TodolistHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Center(
          child: FutureBuilder(
            future: handler.queryDeleteTask(),
            builder: (context, snapshot) {
              // print(snapshot.data);
              if (snapshot.hasData) {
                return ListView.builder(
                  // 유저의 리스트 중 삭제리스트의 길이
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    // 스와이프시 동작
                    return Slidable(
                      startActionPane: ActionPane(
                        extentRatio: .2,
                        motion: const BehindMotion(),
                        children: [
                          SlidableAction(
                            backgroundColor: Colors.blue,
                            icon: Icons.send,
                            label: '복구',
                            onPressed: (context) {
                              // 되돌리기, 복구 로직
                            },
                          ),
                        ],
                      ),
                      endActionPane: ActionPane(
                        extentRatio: .2, // 사이즈 최대 1
                        motion: const BehindMotion(),
                        children: [
                          SlidableAction(
                            backgroundColor: Colors.red,
                            icon: Icons.delete,
                            onPressed: (context) async {
                              // 완전 삭제 로직 alert 창띄우기

                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        // 데이터가 보여지는 곳
                        child: Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  // 하단 선
                                  bottom: BorderSide(
                                      color: Colors.black, width: 1))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: SizedBox(
                              height: 50,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        // 카테고리 이름
                                        SizedBox(
                                          width: 40,
                                          child: Text(
                                              snapshot.data![index].category),
                                        ),
                                        // 카테고리 색상
                                        Container(
                                          width: 10,
                                          color: Colors.black,
                                          // 색상 변경해야함
                                        ),
                                        // 할일
                                        SizedBox(
                                          width: 160,
                                          child: Text(
                                            snapshot.data![index].task,
                                            style: TextStyle(
                                              decoration: snapshot
                                                          .data![index].state ==
                                                      "완료"
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                              decorationThickness: 2,
                                              fontSize: 18,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () =>
                                              checkDialog(index, true),
                                          icon: Icon(
                                            Icons.send,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () =>
                                              checkDialog(index, false),
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
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
                );
              } else {
                // 삭제 리스트에 값이 없을시 문구
                return const Text('삭제된 일이 없습니다');
              }
            },
          ),
        ),
      ),
    );
  }

  // check는 삭제와 되돌리기여부 true 가 되돌림
  checkDialog(index, bool check) {
    Get.defaultDialog(
      title: check ? "되돌리기" : "경고",
      middleText: check ? '정말로 되돌리시겠습니까?' : '정말로 삭제하시겠습니까?',
      backgroundColor: Colors.white,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            // 되돌리는 로직
            // if (check) {
            //   UserList.todoDataList[userIndex].todoList
            //       .add(UserList.todoDataList[userIndex].deleteList[index]);
            // }
            // UserList.todoDataList[userIndex].deleteList
            //     .remove(UserList.todoDataList[userIndex].deleteList[index]);
            Get.back();
            setState(() {});
          },
          child: const Text('네'),
        ),
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('아니오'),
        )
      ],
    );
  }
}
