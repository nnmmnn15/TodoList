import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/model/empty/user_list.dart';
import 'package:todo_list_app/vm/todolist_handler.dart';

class CompletePage extends StatefulWidget {
  const CompletePage({super.key});

  @override
  State<CompletePage> createState() => _CompletePageState();
}

class _CompletePageState extends State<CompletePage> {
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
          child: Column(
            children: [
              // 검색창
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SearchBar(
                  trailing: const [
                    Icon(Icons.search),
                  ],
                  shape: WidgetStateProperty.all(ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
                  padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 10)),
                ),
              ),
              // 완료 목록 리스트 빌더
              // Flexible 은 남은공간을 모두 사용
              Flexible(
                child: FutureBuilder(
                  future: handler.queryCompleteTask(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          // 유저의 투두리스트 중 todoState가 true 인 경우에만
                          return Slidable(
                            endActionPane: ActionPane(
                              extentRatio: .2, // 사이즈 최대 1
                              motion: const BehindMotion(),
                              children: [
                                SlidableAction(
                                  backgroundColor: Colors.red,
                                  icon: Icons.delete,
                                  onPressed: (context) async {
                                    // 삭제 로직
                                    await handler.updateTodolistDelete(
                                        snapshot.data![index].todoid!,
                                        snapshot.data![index].isdelete);
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                            // 데이터 보여지는곳
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              // 할일 완료 제스쳐
                              child: GestureDetector(
                                onDoubleTap: () async {
                                  await handler.updateTodolistState(
                                      snapshot.data![index].todoid!,
                                      snapshot.data![index].state);
                                  setState(() {});
                                },
                                /*
                                  데이터가 담긴 Container
                                  꾸미는 공간 
                                  */
                                child: Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          // 하단선
                                          bottom: BorderSide(
                                              color: Colors.black, width: 1))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: SizedBox(
                                      height: 50,
                                      child: Center(
                                        child: Row(
                                          children: [
                                            // 카테고리 이름
                                            SizedBox(
                                              width: 40,
                                              child: Text(snapshot
                                                  .data![index].category),
                                            ),
                                            // 카테고리 색상
                                            Container(
                                              width: 10,
                                              color: Colors.green[200],
                                            ),
                                            // 할일
                                            Text(
                                              snapshot.data![index].task,
                                              style: TextStyle(
                                                  decoration: snapshot
                                                              .data![index]
                                                              .state ==
                                                          "완료"
                                                      ? TextDecoration
                                                          .lineThrough
                                                      : TextDecoration.none,
                                                  decorationThickness: 2,
                                                  fontSize: 18),
                                            ),
                                          ],
                                        ),
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
                      return const Center(
                        child: Text('완료한 일이 없습니다'),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
