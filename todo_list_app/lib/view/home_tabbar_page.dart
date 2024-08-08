import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/view/category_list_page.dart';
import 'package:todo_list_app/view/complete_page.dart';
import 'package:todo_list_app/view/delete_page.dart';
import 'package:todo_list_app/view/login/login_page.dart';
import 'package:todo_list_app/view/todo_list_page.dart';

class HomeTabbarPage extends StatefulWidget {
  const HomeTabbarPage({super.key});

  @override
  State<HomeTabbarPage> createState() => _HomeTabbarPageState();
}

class _HomeTabbarPageState extends State<HomeTabbarPage>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
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
        backgroundColor: Colors.amber[50],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 200,
              color: const Color.fromRGBO(189, 187, 251, 1),
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: const CircleAvatar(
                  backgroundImage: AssetImage('images/login.png'),
                  radius: 40,
                ),
              ),
            ),
            ListTile(
              title: const Text('로그아웃'),
              onTap: () {
                Get.offAll(const LoginPage());
              },
            ),
          ],
        ),
      ),
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
