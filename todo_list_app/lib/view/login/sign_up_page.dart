import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/model/user_data.dart';
import 'package:todo_list_app/model/user_list.dart';
import 'package:todo_list_app/view/login/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController idController;
  late TextEditingController pwController;
  late TextEditingController pwCheckController;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    pwController = TextEditingController();
    pwCheckController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.amber[100],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 80, 0, 50),
                    child: Text(
                      '회원가입',
                      style: TextStyle(fontSize: 50),
                    ),
                  ),
                  // 아이디 비밀번호 입력란
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: idController,
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      filled: true,
                      fillColor: Color.fromARGB(255, 52, 31, 148),
                      labelText: '아이디를 입력하세요',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: pwController,
                      obscureText: true,
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
                        labelText: '비밀번호를 입력하세요',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: pwCheckController,
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
                      labelText: '비밀번호를 확인하세요',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () => signCheck(),
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(100, 40)),
                          child: const Text('회원가입'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.offAll(const LoginPage());
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(100, 40)),
                          child: const Text('뒤로가기'),
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

  signCheck() {
    FocusScope.of(context).unfocus();
    if (idController.text.trim().isNotEmpty &&
        pwController.text.trim().isNotEmpty &&
        pwCheckController.text.trim().isNotEmpty) {
      for (String id in UserList.userIdList) {
        if (id == idController.text.trim()) {
          errorSnackBar('아이디 중복');
          return;
        }
      }
      if (pwController.text.trim() != pwCheckController.text.trim()) {
        errorSnackBar('비밀번호가 일치하지 않음');
        return;
      }
    } else {
      errorSnackBar('빈칸을 채워주세요');
      return;
    }

    UserList.userIdList.add(idController.text.trim());
    UserList.userPwList.add(pwController.text.trim());
    UserList.todoDataList.add(UserData.init());

    Get.back();
  }

  errorSnackBar(errorMessage) {
    Get.snackbar(
      '기입 오류',
      errorMessage,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2), // 애니메이션 시간
      backgroundColor: Colors.red[400],
      colorText: Colors.white,
    );
  }
}
