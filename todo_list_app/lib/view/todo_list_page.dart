import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/model/todo.dart';
import 'package:todo_list_app/model/user_list.dart';
import 'package:todo_list_app/view/complete_page.dart';
import 'package:todo_list_app/view/delete_page.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  var userIndex = Get.arguments ?? 0;

  late TextEditingController addTodoController;

  @override
  void initState() {
    super.initState();
    addTodoController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () =>
                Get.to(() => const DeletePage(), arguments: userIndex)?.then(
              (value) => setState(() {}),
            ),
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: IconButton(
              onPressed: () => Get.toNamed('/setting'),
              icon: const Icon(
                Icons.settings,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            // complete page 이동 버튼
            ElevatedButton(
              onPressed: () {
                Get.to(
                  () => const CompletePage(),
                  arguments: userIndex,
                )?.then((value) => setState(() {}));
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(340, 70),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: Text(
                '${UserList.todoDataList[userIndex].completeList.length}개의 일을 완료하셨습니다!',
                style: const TextStyle(fontSize: 22),
              ),
            ),
            // todolist가 비어있을때
            UserList.todoDataList[userIndex].todoList.isEmpty
                ? SizedBox(
                    width: 340,
                    child: GestureDetector(
                      onTap: () => addTodoBottomSheet(),
                      child: Card(
                        color: Colors.amber[50],
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: SizedBox(
                            height: 50,
                            child: Center(
                              child: Text(
                                '할 일을 추가하세요!',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                :
                // 할일 목록 todolist에 데이터가 있을때
                SizedBox(
                    width: 340,
                    height: 500,
                    // 리스트뷰 빌더
                    child: ListView.builder(
                      // 유저의 리스트 중 투두리스트의 길이
                      itemCount:
                          UserList.todoDataList[userIndex].todoList.length,
                      itemBuilder: (context, index) {
                        // 스와이프시 삭제
                        return Dismissible(
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
                                UserList
                                    .todoDataList[userIndex].todoList[index]);
                            // 투두리스트에서 제거
                            UserList.todoDataList[userIndex].todoList.remove(
                                UserList
                                    .todoDataList[userIndex].todoList[index]);
                            setState(() {});
                          },
                          // 데이터 보여지는곳
                          child: Card(
                            color: Colors.amber[50],
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: SizedBox(
                                height: 50,
                                child: Center(
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: UserList.todoDataList[userIndex]
                                            .todoList[index].todoState,
                                        onChanged: (value) {
                                          UserList
                                              .todoDataList[userIndex]
                                              .todoList[index]
                                              .todoState = value!;
                                          if (UserList.todoDataList[userIndex]
                                                  .todoList[index].todoState ==
                                              true) {
                                            // 완료 리스트에 추가
                                            UserList.todoDataList[userIndex]
                                                .completeList
                                                .add(UserList
                                                    .todoDataList[userIndex]
                                                    .todoList[index]);
                                            // 투두리스트에서 제거
                                            UserList.todoDataList[userIndex]
                                                .todoList
                                                .remove(UserList
                                                    .todoDataList[userIndex]
                                                    .todoList[index]);
                                          }
                                          setState(() {});
                                        },
                                      ),
                                      Text(
                                        UserList.todoDataList[userIndex]
                                            .todoList[index].todoText,
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addTodoBottomSheet(),
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
        height: 60,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          color: Colors.purple[100],
        ),
        child: Row(
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
      ),
    );
  }

  addTodo() {
    if (addTodoController.text.trim().isEmpty) {
      errorSnackBar('할일을 작성해주세요');
    } else {
      UserList.todoDataList[userIndex].todoList
          .add(Todo(todoText: addTodoController.text, todoState: false));
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
}
