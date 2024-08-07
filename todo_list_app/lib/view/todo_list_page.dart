import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/model/category_set.dart';
import 'package:todo_list_app/model/todo.dart';
import 'package:todo_list_app/model/user_list.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  var userIndex = Get.arguments ?? 0;

  late TextEditingController addTodoController;
  late Color categoryColor;
  late String categoryString;

  @override
  void initState() {
    super.initState();
    addTodoController = TextEditingController();
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
              Flexible(
                // 리스트뷰 빌더
                child: ListView.builder(
                  // 유저의 리스트 중 투두리스트의 길이
                  itemCount:
                      UserList.todoDataList[userIndex].todoList.length + 1,
                  itemBuilder: (context, index) {
                    // 스와이프시 삭제
                    return UserList.todoDataList[userIndex].todoList.length ==
                            index
                        ?
                        // 마지막 문구 (추가버튼)
                        TextButton(
                            onPressed: () => actionSheet(),
                            // height: 50,
                            // alignment: Alignment.center,
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
                        Dismissible(
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
                                child: Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
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
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => actionSheet(), //addTodoBottomSheet(),
        backgroundColor: Colors.deepPurple[200],
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  addTodoBottomSheet() {
    Get.bottomSheet(
      Container(
        width: 500,
        height: 120,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            color: categoryColor),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 340,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
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
                IconButton(
                  onPressed: () => addTodo(),
                  icon: const Icon(Icons.arrow_forward_ios),
                )
              ],
            ),
            TextButton(
              onPressed: () => calandarDialog(),
              child: Text('day'),
            ),
          ],
        ),
      ),
    );
  }

  addTodo() {
    if (addTodoController.text.trim().isEmpty) {
      errorSnackBar('할일을 작성해주세요');
    } else {
      UserList.todoDataList[userIndex].todoList.add(Todo(
          todoText: addTodoController.text,
          categorySet: CategorySet(
              categoryColor: categoryColor, categoryName: categoryString),
          todoState: false));
      addTodoController.text = '';
      Get.back();
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
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Row(
          children: [
            const Text('카테고리 선택'),
          ],
        ),
        message: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                categoryColor = Colors.deepPurple[100]!;
                categoryString = '심부름';
                Get.back();
                addTodoBottomSheet();
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(30, 100), backgroundColor: Colors.grey[100]),
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
                  fixedSize: Size(30, 100), backgroundColor: Colors.grey[100]),
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
                  fixedSize: Size(30, 100), backgroundColor: Colors.grey[100]),
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
                  fixedSize: Size(30, 100), backgroundColor: Colors.grey[100]),
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

  calandarDialog() {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true, //showCupertinoDialog 영역 외에 눌렀을 때 닫게 해줌
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment
              .bottomCenter, //특정 위젯이 어디에 정렬을 해야되는지 모르면 height값줘도 최대한에 사이즈를 먹음
          child: Container(
            color: Colors.white,
            height: 300,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode
                  .date, //CupertinoDatePickerMode에서 일시, 시간 등 고름
              onDateTimeChanged: (DateTime date) {
                print(DateTime.now());
                var a = DateTime.now().toString().split(' ');
                print(a[0]);
                print(date);
              },
            ), //날짜)
          ),
        );
      },
    );
  }
}// ed
