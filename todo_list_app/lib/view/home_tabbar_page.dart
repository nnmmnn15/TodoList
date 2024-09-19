import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/model/user.dart';
import 'package:todo_list_app/view/category_list_page.dart';
import 'package:todo_list_app/view/complete_page.dart';
import 'package:todo_list_app/view/delete_page.dart';
import 'package:todo_list_app/view/login/login_page.dart';
import 'package:todo_list_app/view/modify_category.dart';
import 'package:todo_list_app/view/todo_list_page.dart';
import 'package:todo_list_app/view/user_modify.dart';
import 'package:todo_list_app/vm/user_data_handler.dart';

class HomeTabbarPage extends StatefulWidget {
  const HomeTabbarPage({super.key});

  @override
  State<HomeTabbarPage> createState() => _HomeTabbarPageState();
}

class _HomeTabbarPageState extends State<HomeTabbarPage>
    with SingleTickerProviderStateMixin {
  final UserDataHandler userHandler = UserDataHandler();
  late TabController controller;
  late User user;
  late bool isRun;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
    isRun = false;
    getData();
  }

  getData() async {
    isRun = false;
    List<User> userData = await userHandler.queryUser();
    user = userData[0];
    isRun = true;
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
        backgroundColor: const Color.fromARGB(255, 23, 7, 96),
        foregroundColor: Colors.white,
        centerTitle: false,
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: const [
          TodoListPage(),
          CategoryListPage(),
          CompletePage(),
          DeletePage(),
        ],
      ),
      drawer: Drawer(
          backgroundColor: const Color.fromRGBO(255, 240, 195, 1),
          child: isRun
              ? ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Container(
                      height: 200,
                      color: const Color.fromRGBO(189, 187, 251, 1),
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: CircleAvatar(
                                backgroundImage: user.profile == null
                                    ? const AssetImage('images/login.png')
                                    : MemoryImage(user.profile!),
                                radius: 40,
                              ),
                            ),
                            Text(
                              user.name,
                              style: const TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      title: const Text(
                        '카테고리 수정',
                      ),
                      onTap: () {
                        Get.back();
                        Get.to(
                          () => const ModifyCategory(),
                        );
                      },
                    ),
                    ListTile(
                      title: const Text(
                        '회원정보 수정',
                      ),
                      onTap: () {
                        Get.back();
                        Get.to(
                          () => const UserModify(),
                        )!
                            .then((value) => getData());
                      },
                    ),
                    ListTile(
                      title: const Text(
                        '로그아웃',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () {
                        Get.offAll(const LoginPage());
                      },
                    ),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                )),
      bottomNavigationBar: Container(
        color: Colors.amberAccent,
        height: 100,
        child: TabBar(
          controller: controller,
          labelColor: const Color.fromARGB(255, 23, 7, 96),
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: const Color.fromARGB(255, 23, 7, 96),
          indicatorWeight: 5,
          tabs: const [
            Tab(
              icon: Icon(Icons.list),
              text: '할일 목록',
            ),
            Tab(
              icon: Icon(Icons.category),
              text: '카테고리',
            ),
            Tab(
              icon: Icon(Icons.check),
              text: '완료 목록',
            ),
            Tab(
              icon: Icon(Icons.delete),
              text: '삭제목록',
            ),
          ],
        ),
      ),
    );
  }
}
