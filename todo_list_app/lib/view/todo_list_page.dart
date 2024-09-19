import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_list_app/model/todolist.dart';
import 'package:todo_list_app/view/modify_category.dart';
import 'package:todo_list_app/vm/category_handler.dart';
import 'package:todo_list_app/vm/convert_color.dart';
import 'package:todo_list_app/vm/todolist_handler.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  late TodolistHandler handler;
  late CategoryHandler categoryHandler;
  late ConvertColor convertColor;

  final GetStorage box = GetStorage();

  late TextEditingController addTodoController;
  late TextEditingController categoryController;
  late Color categoryColor;
  late String categoryString;
  late DateTime taskDay; // 일정 날짜
  late DateTime now; // 현재 날짜
  late bool addCheck; // 추가, 수정 확인용 true일때 추가

  @override
  void initState() {
    // print(box.read("nmcTodoUserSeq"));
    super.initState();
    addTodoController = TextEditingController();
    categoryController = TextEditingController();
    now = DateTime.now();

    handler = TodolistHandler();
    categoryHandler = CategoryHandler();
    convertColor = ConvertColor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  border: Border(
                      // 하단선
                      bottom: BorderSide(color: Colors.black, width: 1))),
              child: const Text(
                '남은 할일',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
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
                                // actionSheet();
                                popCategory();
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
                                    addTodoController.text =
                                        snapshot.data![index].task;
                                    taskDay = DateTime.parse(
                                        snapshot.data![index].tododate);
                                    categoryColor = convertColor.strToColor(
                                        snapshot.data![index].color);
                                    categoryString =
                                        snapshot.data![index].category;
                                    addCheck = false;
                                    addTodoBottomSheet(
                                        snapshot.data![index].todoid);
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
                                                MainAxisAlignment.spaceBetween,
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
                                                          convertColor
                                                              .strToColor(
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .color)),
                                                  // 할일
                                                  SizedBox(
                                                    width: 160,
                                                    child: Text(
                                                      snapshot
                                                          .data![index].task,
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
                                                        decorationThickness: 2,
                                                        fontSize: 18,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
      // 플로팅 버튼
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popCategory();
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
  addTodoBottomSheet([int? todoid]) {
    /* 
    바텀 시트는 위젯 내부의 상태를 관리하기위해
    StatefulBuilder 가 필요
    */
    Get.bottomSheet(Builder(
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              width: MediaQuery.of(context).size.width,
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
                        onPressed: () =>
                            addCheck ? addTodo() : updateTodo(todoid!),
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
                          // actionSheet();
                          popCategory(todoid);
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
  addTodo() async {
    // 입력란이 비어있을 때
    if (addTodoController.text.trim().isEmpty) {
      errorSnackBar('할일을 작성해주세요');
    } else {
      Todolist todolist = Todolist(
        userSeq: box.read("nmcTodoUserSeq"),
        tododate:
            '${taskDay.year}-${taskDay.month.toString().padLeft(2, '0')}-${taskDay.day}',
        task: addTodoController.text,
        category: categoryString,
        state: "미완료",
        isdelete: "안버림",
      );

      int result = await handler.insertTask(todolist);

      if (result == 0) {
        errorSnackBar("추가에 오류가 있습니다\n다시 시도해 주세요");
      } else {
        // 입력후 텍스트필드 초기화
        addTodoController.text = '';
        Get.back();
        // sortTodoList();
        setState(() {});
      }
    }
  }

  // 할 일 수정시 동작
  updateTodo(int todoid) async {
    if (addTodoController.text.trim().isEmpty) {
      errorSnackBar('할일을 작성해주세요');
    } else {
      Todolist todolist = Todolist(
        todoid: todoid,
        userSeq: box.read("nmcTodoUserSeq"),
        tododate:
            '${taskDay.year}-${taskDay.month.toString().padLeft(2, '0')}-${taskDay.day.toString().padLeft(2, '0')}',
        task: addTodoController.text,
        category: categoryString,
      );

      int result = await handler.updateTask(todolist);

      if (result == 0) {
        errorSnackBar("수정중 오류가 있습니다");
      } else {
        // 입력후 텍스트필드 초기화
        addTodoController.text = '';
        Get.back();
        // sortTodoList();
        setState(() {});
      }
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

  popCategory([int? todoid]) {
    Get.dialog(
      AlertDialog(
        title: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 45,
          child: Stack(
            children: [
              const Positioned(
                child: Text(
                  '카테고리 선택',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Positioned(
                right: 0,
                child: TextButton(
                  onPressed: () {
                    Get.back();
                    Get.to(() => const ModifyCategory())!.then(
                      (value) => popCategory(),
                    );
                  },
                  child: const Text('카테고리 편집'),
                ),
              )
            ],
          ),
        ),
        content: FutureBuilder(
          future: categoryHandler.queryCategory(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.width * 0.3,
                child: GridView.builder(
                  itemCount: snapshot.data!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 한줄당 갯수
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    return TextButton(
                      onPressed: () {
                        categoryColor = convertColor
                            .strToColor(snapshot.data![index].color);
                        categoryString = snapshot.data![index].name;
                        Get.back();
                        addTodoBottomSheet(todoid);
                      },
                      style: ElevatedButton.styleFrom(
                          // fixedSize: const Size(30, 100),
                          backgroundColor: Colors.grey[100]),
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: convertColor
                                  .strToColor(snapshot.data![index].color),
                            ),
                            Text(snapshot.data![index].name),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return const Center(
                child: Text('카테고리가 없습니다'),
              );
            }
          },
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
} // ed
