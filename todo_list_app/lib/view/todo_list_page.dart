import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_list_app/vm/todolist_handler.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  // 지워야함
  // var userIndex = Get.arguments ?? 0;

  late TodolistHandler handler;

  final GetStorage box = GetStorage();

  late TextEditingController addTodoController;
  late Color categoryColor;
  late String categoryString;
  late DateTime taskDay; // 일정 날짜
  late DateTime now; // 현재 날짜
  late bool addCheck; // 추가, 수정 확인용 true일때 추가
  late int updateIndex; // 수정시 참고할 인덱스

  @override
  void initState() {
    // print(box.read("nmcTodoUserSeq"));
    super.initState();
    addTodoController = TextEditingController();
    now = DateTime.now();
    categoryColor = Colors.amber;
    categoryString = "";
    handler = TodolistHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              // 할일 목록 todolist에 데이터가 있을때
              FutureBuilder(
                future: handler.queryTask(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Flexible(
                      child: ListView.builder(
                        // 유저의 리스트 중 투두리스트의 길이 + 1
                        // + 1 은 마지막에 일정 추가 버튼을 위함
                        itemCount: snapshot.data!.length + 1,
                        itemBuilder: (context, index) {
                          // 마지막 위치의 여부 판단
                          // 마지막 버튼은 일정 추가 버튼을 하기 위함
                          return snapshot.data!.length == index
                              ?
                              // 마지막 문구 (추가버튼)
                              TextButton(
                                  onPressed: () {
                                    actionSheet();
                                    addTodoController.text = '';
                                    now = DateTime.now();
                                    taskDay =
                                        DateTime(now.year, now.month, now.day);
                                    addCheck = true;
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add),
                                      Text(
                                        '일정을 추가하세요',
                                      ),
                                    ],
                                  ),
                                )
                              :
                              // To do list 데이터
                              // 스와이프시 삭제
                              Slidable(
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    // 할일 완료 제스쳐
                                    child: GestureDetector(
                                      // 더블 클릭시 상태변화
                                      onDoubleTap: () async {
                                        await handler.updateTodolistState(
                                            snapshot.data![index].todoid!,
                                            snapshot.data![index].state);
                                        setState(() {});
                                      },
                                      // 한번 터치시 업데이트, 수정
                                      onTap: () {
                                        // addTodoController.text = UserList
                                        //     .todoDataList[userIndex]
                                        //     .todoList[index]
                                        //     .todoText;
                                        // taskDay = UserList.todoDataList[userIndex]
                                        //     .todoList[index].deadline;
                                        // categoryColor = UserList
                                        //     .todoDataList[userIndex]
                                        //     .todoList[index]
                                        //     .categorySet
                                        //     .categoryColor;
                                        // categoryString = UserList
                                        //     .todoDataList[userIndex]
                                        //     .todoList[index]
                                        //     .categorySet
                                        //     .categoryName;
                                        addCheck = false;
                                        updateIndex = index;
                                        addTodoBottomSheet();
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                // 하단선
                                                bottom: BorderSide(
                                                    color: Colors.black,
                                                    width: 1))),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: SizedBox(
                                            height: 50,
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      // 카테고리 명
                                                      SizedBox(
                                                          width: 40,
                                                          child: Text(snapshot
                                                              .data![index]
                                                              .category)),
                                                      // 카테고리 색
                                                      Container(
                                                          width: 10,
                                                          color: // 텍스트를 Color로 바꿔야함
                                                              Colors.blue[100]),
                                                      // 할일
                                                      SizedBox(
                                                        width: 160,
                                                        child: Text(
                                                          snapshot.data![index]
                                                              .task,
                                                          style: TextStyle(
                                                            // 할일의 상태에 따라 취소선 true 일때 취소선
                                                            decoration: snapshot
                                                                        .data![
                                                                            index]
                                                                        .state ==
                                                                    "완료"
                                                                ? TextDecoration
                                                                    .lineThrough
                                                                : TextDecoration
                                                                    .none,
                                                            decorationThickness:
                                                                2,
                                                            fontSize: 18,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  // 날짜 표시
                                                  Text(
                                                      '${snapshot.data![index].tododate}까지'),
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
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      // 플로팅 버튼
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // addTodoBottomSheet();
          actionSheet();
          // popCategory();
          addTodoController.text = '';
          now = DateTime.now();
          taskDay = DateTime(now.year, now.month, now.day);
          addCheck = true;
        }, //addTodoBottomSheet(),
        backgroundColor: Colors.deepPurple[200],
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  // 할일 추가 바텀시트
  // int? index 인덱스 값이 있을수도 있고 없을 수도 있음
  addTodoBottomSheet() {
    /* 
    바텀 시트는 위젯 내부의 상태를 관리하기위해
    StatefulBuilder 가 필요
    */
    Get.bottomSheet(Builder(
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              width: 700,
              height: 110,
              // 바텀 시트 데코레이션
              decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                  color: categoryColor),
              child: Column(
                children: [
                  // 입력 상단
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 340,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          // 할 일 작성 텍스트 필드
                          child: TextField(
                            controller: addTodoController,
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: '추가할 일을 적어주세요',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none,
                                )),
                          ),
                        ),
                      ),
                      // 작성 완료 버튼
                      IconButton(
                        onPressed: () => addCheck ? addTodo() : updateTodo(),
                        icon: const Icon(Icons.arrow_forward_ios),
                      )
                    ],
                  ),

                  // 입력 하단
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          // 달력 (날짜 선택)
                          showDatePicker(
                            context: context,
                            barrierDismissible: false,
                            // 달력 시작일
                            firstDate: now.subtract(const Duration(days: 1825)),
                            // 선택된 달력일
                            initialDate: taskDay,
                            // 달력 종료일
                            lastDate: now.add(const Duration(days: 1825)),
                          ).then(
                            (value) {
                              if (value != null) {
                                taskDay = value;
                                setState(() {});
                              }
                            },
                          );
                        },
                        child: Text('${taskDay.month}월 ${taskDay.day}일'),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                          actionSheet();
                        },
                        child: Text('$categoryString / 카테고리 변경'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    ));
  }

  // 할 일 추가시 동작
  addTodo() {
    // 입력란이 비어있을 때
    if (addTodoController.text.trim().isEmpty) {
      errorSnackBar('할일을 작성해주세요');
    } else {
      // 추가동작
      // UserList.todoDataList[userIndex].todoList.add(Todo(
      //     todoText: addTodoController.text,
      //     categorySet: CategorySet(
      //         categoryColor: categoryColor, categoryName: categoryString),
      //     todoState: false,
      //     deadline: taskDay));
      // 입력후 텍스트필드 초기화
      addTodoController.text = '';
      Get.back();
      // sortTodoList();
      setState(() {});
    }
  }

  // 할 일 수정시 동작
  updateTodo() {
    if (addTodoController.text.trim().isEmpty) {
      errorSnackBar('할일을 작성해주세요');
    } else {
      // 수정동작
      // UserList.todoDataList[userIndex].todoList[updateIndex] = Todo(
      //     todoText: addTodoController.text,
      //     categorySet: CategorySet(
      //         categoryColor: categoryColor, categoryName: categoryString),
      //     todoState: false,
      //     deadline: taskDay);
      // 입력후 텍스트필드 초기화
      addTodoController.text = '';
      Get.back();
      // sortTodoList();
      setState(() {});
    }
  }

  errorSnackBar(errorMessage) {
    Get.snackbar(
      '입력 오류',
      errorMessage,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(milliseconds: 1500), // 애니메이션 시간
      backgroundColor: Colors.red[400],
      colorText: Colors.white,
    );
  }

  // 카테고리 선택 액션 시트
  actionSheet() {
    // 액션시트
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Row(
          children: [
            Text('카테고리 선택'),
          ],
        ),
        // 카테고리 선택 버튼
        message: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                categoryColor = Colors.deepPurple[100]!;
                categoryString = '심부름';
                print(1);
                Get.back();
                addTodoBottomSheet();
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(30, 100),
                  backgroundColor: Colors.grey[100]),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.deepPurple[100],
                    ),
                    const Text('심부름'),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                categoryColor = Colors.blue[100]!;
                categoryString = '약속';
                Get.back();
                addTodoBottomSheet();
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(30, 100),
                  backgroundColor: Colors.grey[100]),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.blue[100],
                    ),
                    const Text('약속'),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                categoryColor = Colors.green[100]!;
                categoryString = '일상';
                Get.back();
                addTodoBottomSheet();
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(30, 100),
                  backgroundColor: Colors.grey[100]),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.green[100],
                    ),
                    const Text('일상'),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                categoryColor = Colors.red[100]!;
                categoryString = '중요일정';
                Get.back();
                addTodoBottomSheet();
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(30, 100),
                  backgroundColor: Colors.grey[100]),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.red[100],
                    ),
                    const Text('중요일정'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // popCategory() {
  //   Get.dialog(
  //     AlertDialog(
  //       title: const Text(
  //         '카테고리 선택',
  //         style: TextStyle(fontSize: 14),
  //       ),
  //       content: TextButton(
  //         onPressed: () {
  //           categoryColor = Colors.deepPurple[100]!;
  //           categoryString = '심부름';
  //           Get.back();
  //           addTodoBottomSheet();
  //         },
  //         style: ElevatedButton.styleFrom(
  //             fixedSize: const Size(30, 100),
  //             backgroundColor: Colors.grey[100]),
  //         child: Padding(
  //           padding: const EdgeInsets.all(0),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               CircleAvatar(
  //                 radius: 15,
  //                 backgroundColor: Colors.deepPurple[100],
  //               ),
  //               const Text('심부름'),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
} // ed
