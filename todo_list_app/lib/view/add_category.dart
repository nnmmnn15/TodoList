import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_list_app/model/todo_category.dart';
import 'package:todo_list_app/vm/category_handler.dart';
import 'package:todo_list_app/vm/convert_color.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final GetStorage box = GetStorage();
  late TextEditingController categoryController;
  late ConvertColor convertColor;
  late CategoryHandler handler;
  late List<Color> colorList;
  late int selectIndex;
  late String? errorText;
  late String colorError;

  @override
  void initState() {
    super.initState();
    categoryController = TextEditingController();
    convertColor = ConvertColor();
    handler = CategoryHandler();
    errorText = null;
    colorError = '';
    selectIndex = -1;
    colorList = [
      const Color.fromRGBO(229, 115, 115, 1), // 빨강
      const Color.fromRGBO(255, 224, 178, 1), // 주황
      const Color.fromRGBO(200, 230, 201, 1), // 초록
      const Color.fromRGBO(187, 222, 251, 1), // 하늘
      const Color.fromRGBO(225, 190, 231, 1), // 보라
      const Color.fromRGBO(248, 187, 208, 1), // 분홍
      const Color.fromRGBO(149, 117, 205, 1), // 진보라
      Colors.grey, // 회색
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.amber[100],
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 23, 7, 96),
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextFormField(
                    controller: categoryController,
                    decoration: InputDecoration(
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedErrorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      filled: true,
                      fillColor: Colors.white,
                      labelText: '카테고리 이름을 입력하세요',
                      errorText: errorText,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Wrap(
                            spacing: 20, // 컬럼 간 간격
                            runSpacing: 20, // 행 간 간격
                            children: List.generate(
                              colorList.length,
                              (index) {
                                return GestureDetector(
                                  onTap: () {
                                    selectIndex = index;
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width -
                                            136) /
                                        4,
                                    height: (MediaQuery.of(context).size.width -
                                            136) /
                                        4,
                                    decoration: BoxDecoration(
                                      color: colorList[index],
                                      shape: BoxShape.circle,
                                    ),
                                    child: selectIndex == index
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 40,
                                          )
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          colorError,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextButton(
                    onPressed: () {
                      // 추가 동작
                      checkData();
                      Get.back();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 47, 18, 173),
                      foregroundColor: Colors.white,
                      fixedSize: Size(MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.height * 0.05),
                    ),
                    child: const Text('추가하기'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Functions ---
  checkData() async {
    bool isText = checkText();
    bool isColor = checkColor();
    setState(() {});

    if (isText && isColor) {
      TodoCategory category = TodoCategory(
        userSeq: box.read('nmcTodoUserSeq'),
        name: categoryController.text.trim(),
        color: convertColor.colorToStr(colorList[selectIndex]),
      );
      await handler.insertCategory(category);
    }
  }

  bool checkText() {
    if (categoryController.text.trim().isEmpty) {
      errorText = '카테고리를 입력해주세요!';
      return false;
    } else {
      errorText = null;
      return true;
    }
  }

  bool checkColor() {
    if (selectIndex < 0) {
      colorError = '색상을 선택해주세요';
      return false;
    } else {
      colorError = '';
      return true;
    }
  }
} // ed
