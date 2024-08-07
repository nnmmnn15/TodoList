import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/model/user_list.dart';
import 'package:todo_list_app/view/home_tabbar_page.dart';
import 'package:todo_list_app/view/login/sign_up_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController idController;
  late TextEditingController pwController;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    pwController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('To Do List'),
            Image.asset(
              'images/todolist.png',
              width: 250,
            ),

            // 아이디 비밀번호 입력란
            TextField(
              controller: idController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.grey,
                labelText: '아이디를 입력하세요',
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            TextField(
              controller: pwController,
              obscureText: true,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.grey,
                labelText: '비밀번호를 입력하세요',
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),

            ElevatedButton(
              onPressed: () => checkUser(),
              style: ElevatedButton.styleFrom(fixedSize: const Size(100, 40)),
              child: const Text('로그인'),
            ),
            ElevatedButton(
              onPressed: () => Get.to(()=>const SignUpPage()),
              style: ElevatedButton.styleFrom(fixedSize: const Size(100, 40)),
              child: const Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }

  checkUser() {
    for (int userIndex = 0; userIndex < UserList.userIdList.length; userIndex++) {
      if (idController.text.trim() == UserList.userIdList[userIndex] &&
          pwController.text.trim() == UserList.userPwList[userIndex]) {
        Get.offAll(
          () => const HomeTabbarPage(),
          arguments: userIndex,
        );
        return;
      }
    }
    errorSnackBar('아이디 또는 비밀번호가 일치하지 않습니다');
  }

  errorSnackBar(errorMessage) {
    Get.snackbar(
      '로그인 오류',
      errorMessage,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2), // 애니메이션 시간
      backgroundColor: Colors.red[400],
      colorText: Colors.white,
    );
  }
}
