import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/model/empty/user_list.dart';

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
                child: ListView.builder(
                  itemCount: UserList.todoDataList[userIndex].todoList.length,
                  itemBuilder: (context, index) {
                    // 유저의 투두리스트 중 todoState가 true 인 경우에만
                    return UserList
                            .todoDataList[userIndex].todoList[index].todoState
                        // 스와이프 시 삭제 동작
                        ? Dismissible(
                            key: ValueKey(UserList
                                .todoDataList[userIndex].todoList[index]),
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
                            // 삭제 동작(스와이프)시 실행
                            onDismissed: (direction) {
                              // 삭제 리스트에 추가
                              UserList.todoDataList[userIndex].deleteList.add(
                                  UserList
                                      .todoDataList[userIndex].todoList[index]);
                              // 투두리스트에서 제거
                              UserList.todoDataList[userIndex].todoList.remove(
                                  UserList
                                      .todoDataList[userIndex].todoList[index]);
                              setState(() {});
                            },
                            // 데이터 보여지는곳
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              // 할일 완료 제스쳐
                              child: GestureDetector(
                                onDoubleTap: () {
                                  UserList.todoDataList[userIndex]
                                          .todoList[index].todoState =
                                      !UserList.todoDataList[userIndex]
                                          .todoList[index].todoState;
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
                                              child: Text(UserList
                                                  .todoDataList[userIndex]
                                                  .todoList[index]
                                                  .categorySet
                                                  .categoryName),
                                            ),
                                            // 카테고리 색상
                                            Container(
                                              width: 10,
                                              color: UserList
                                                  .todoDataList[userIndex]
                                                  .todoList[index]
                                                  .categorySet
                                                  .categoryColor,
                                            ),
                                            // 할일
                                            Text(
                                              UserList.todoDataList[userIndex]
                                                  .todoList[index].todoText,
                                              style: TextStyle(
                                                  decoration: UserList
                                                          .todoDataList[
                                                              userIndex]
                                                          .todoList[index]
                                                          .todoState
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
                          )
                        // 할일이 완료되지 않은 값을 받았을때 빈 박스
                        : const SizedBox.shrink();
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
