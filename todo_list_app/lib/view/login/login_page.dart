import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/model/empty/user_list.dart';
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.amber[100],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: Text(
                      'To Do List',
                      style: TextStyle(fontSize: 50),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Image.asset(
                      'images/todolist.png',
                      width: 250,
                    ),
                  ),

                  // 아이디 비밀번호 입력란
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: idController,
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          filled: true,
                          fillColor: Color.fromARGB(255, 52, 31, 148),
                          labelText: '아이디를 입력하세요',
                          labelStyle: TextStyle(color: Colors.white),
                          counterStyle: TextStyle(color: Colors.white)),
                    ),
                  ),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: pwController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      filled: true,
                      fillColor: Color.fromARGB(255, 52, 31, 148),
                      labelText: '비밀번호를 입력하세요',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () => checkUser(),
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(100, 40)),
                          child: const Text('로그인'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(() => const SignUpPage());
                          },
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(100, 40)),
                          child: const Text('회원가입'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  checkUser() {
    for (int userIndex = 0;
        userIndex < UserList.userIdList.length;
        userIndex++) {
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
