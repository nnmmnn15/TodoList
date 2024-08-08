import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/model/user_list.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  var userIndex = Get.arguments ?? 0;
  late List categoryNameList;
  late List categoryColor;

  @override
  void initState() {
    super.initState();
    categoryNameList = ['심부름', '약속', '일상', '중요일정'];
    categoryColor = [
      Colors.deepPurple[100],
      Colors.blue[100],
      Colors.green[100],
      Colors.red[100]
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // 카테고리 수 만큼
              for (int i = 0; i < categoryNameList.length; i++)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 250,
                          height: 50,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              // 카테고리 색상이 상단 Bar로 존재
                              color: categoryColor[i],
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(15))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  // 카테고리 명
                                  categoryNameList[i],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  // 기간
                                  '기간',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // 할 일이 보여지는 공간
                        Flexible(
                          child: ListView.builder(
                            itemCount: UserList
                                .todoDataList[userIndex].todoList.length,
                            itemBuilder: (context, index) {
                              // 카테고리명이 현재 리스트뷰의 카테고리 명과 동일 여부
                              return UserList
                                          .todoDataList[userIndex]
                                          .todoList[index]
                                          .categorySet
                                          .categoryName ==
                                      categoryNameList[i]
                                  // 스와이프시 삭제
                                  ? Dismissible(
                                      key: ValueKey(UserList
                                          .todoDataList[userIndex]
                                          .todoList[index]),
                                      direction: DismissDirection.endToStart,
                                      background: Container(
                                        color: Colors.red,
                                        alignment: Alignment.centerRight,
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      // 스와이프시 로직
                                      onDismissed: (direction) {
                                        // 삭제 리스트에 추가
                                        UserList
                                            .todoDataList[userIndex].deleteList
                                            .add(UserList
                                                .todoDataList[userIndex]
                                                .todoList[index]);
                                        // 투두리스트에서 제거
                                        UserList
                                            .todoDataList[userIndex].todoList
                                            .remove(UserList
                                                .todoDataList[userIndex]
                                                .todoList[index]);
                                        setState(() {});
                                      },
                                      //
                                      child: GestureDetector(
                                        // 더블 터치시 완료 표시
                                        onDoubleTap: () {
                                          UserList.todoDataList[userIndex]
                                                  .todoList[index].todoState =
                                              !UserList.todoDataList[userIndex]
                                                  .todoList[index].todoState;
                                          setState(() {});
                                        },
                                        child: Container(
                                          // 밑줄 하단선
                                          decoration: const BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.black,
                                                    width: 1)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: SizedBox(
                                              height: 50,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  // 할 일
                                                  Text(
                                                    UserList
                                                        .todoDataList[userIndex]
                                                        .todoList[index]
                                                        .todoText,
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
                                                      fontSize: 18
                                                    ),
                                                  ),
                                                  // 기간
                                                  Text(
                                                      '${UserList.todoDataList[userIndex].todoList[index].deadline.toString().split(' ')[0].split('-')[1]}월'
                                                      '${UserList.todoDataList[userIndex].todoList[index].deadline.toString().split(' ')[0].split('-')[2]}일')
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  :
                                  // 동일하지 않을 시
                                  const SizedBox.shrink();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
