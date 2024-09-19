import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list_app/model/todo_category.dart';
import 'package:todo_list_app/vm/category_handler.dart';
import 'package:todo_list_app/vm/convert_color.dart';
import 'package:todo_list_app/vm/todolist_handler.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  late List<TodoCategory> categoryList;
  late List<String> categoryNameList;
  late ConvertColor convertColor;
  late List categoryColor; //
  late CategoryHandler categoryHandler;
  late TodolistHandler handler;
  late String dropdownValue;
  late bool isReady;
  late int dropdownIndex;

  @override
  void initState() {
    super.initState();
    categoryHandler = CategoryHandler();
    handler = TodolistHandler();
    convertColor = ConvertColor();
    categoryList = [];

    isReady = false;
    getData();
  }

  getData() async {
    categoryList = await categoryHandler.queryCategory();
    categoryNameList = [];
    for (TodoCategory data in categoryList) {
      categoryNameList.add(data.name);
    }
    dropdownValue = categoryNameList[0];
    dropdownIndex = 0;
    isReady = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber[100],
        body: isReady
            ? SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    // 카테고리 색상이 상단 Bar로 존재
                                    color: convertColor.strToColor(
                                        categoryList[dropdownIndex].color),
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(15))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      DropdownButton(
                                        dropdownColor: convertColor.strToColor(
                                            categoryList[dropdownIndex].color),
                                        iconEnabledColor: Colors.white,
                                        value: dropdownValue, // 현재 값
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),
                                        items: categoryNameList
                                            .map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(
                                              items,
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          dropdownValue = value!;
                                          dropdownIndex =
                                              categoryNameList.indexOf(value);
                                          setState(() {});
                                        },
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
                                child: FutureBuilder(
                                  future: handler
                                      .queryTaskByCategory(dropdownValue),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return ListView.builder(
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index) {
                                          // 카테고리명이 현재 리스트뷰의 카테고리 명과 동일 여부
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
                                                    await handler
                                                        .updateTodolistDelete(
                                                            snapshot
                                                                .data![index]
                                                                .todoid!,
                                                            snapshot
                                                                .data![index]
                                                                .isdelete);
                                                    setState(() {});
                                                  },
                                                ),
                                              ],
                                            ),
                                            //
                                            child: GestureDetector(
                                              // 더블 터치시 완료 표시
                                              onDoubleTap: () async {
                                                await handler
                                                    .updateTodolistState(
                                                        snapshot.data![index]
                                                            .todoid!,
                                                        snapshot.data![index]
                                                            .state);
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
                                                  padding: const EdgeInsets
                                                      .symmetric(
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
                                                        // 기간
                                                        Text(snapshot
                                                            .data![index]
                                                            .tododate),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      return const Text('할일이 없습니다');
                                    }
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
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}
