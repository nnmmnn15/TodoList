import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/view/add_category.dart';
import 'package:todo_list_app/vm/category_handler.dart';
import 'package:todo_list_app/vm/convert_color.dart';

class ModifyCategory extends StatefulWidget {
  const ModifyCategory({super.key});

  @override
  State<ModifyCategory> createState() => _ModifyCategoryState();
}

class _ModifyCategoryState extends State<ModifyCategory> {
  late CategoryHandler handler;
  late ConvertColor convertColor;

  @override
  void initState() {
    super.initState();
    handler = CategoryHandler();
    convertColor = ConvertColor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      appBar: AppBar(
        title: const Text('카테고리 편집'),
        backgroundColor: const Color.fromARGB(255, 23, 7, 96),
        foregroundColor: Colors.white,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(
                () => const AddCategory(),
              )!
                  .then((value) => setState(() {}));
            },
            icon: const Icon(Icons.add_circle),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: FutureBuilder(
                  future: handler.queryCategory(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: index == 0
                                  ? const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12))
                                  : index == snapshot.data!.length - 1
                                      ? const BorderRadius.only(
                                          bottomLeft: Radius.circular(12),
                                          bottomRight: Radius.circular(12))
                                      : BorderRadius.circular(0),
                              color: Colors.white,
                            ),
                            child: ListTile(
                              leading: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: convertColor
                                      .strToColor(snapshot.data![index].color),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              title: Text(snapshot.data![index].name),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text('카테고리가 없습니다'),
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
