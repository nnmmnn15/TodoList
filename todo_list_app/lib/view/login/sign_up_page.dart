import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/model/user.dart';
// import 'package:todo_list_app/model/empty/user_data.dart';
// import 'package:todo_list_app/model/empty/user_list.dart';
// import 'package:todo_list_app/model/user.dart';
import 'package:todo_list_app/view/login/login_page.dart';
import 'package:todo_list_app/vm/database_handler.dart';
import 'package:todo_list_app/vm/user_data_handler.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late UserDataHandler handler;
  late DatabaseHandler aa;

  late TextEditingController idController;
  late TextEditingController pwController;
  late TextEditingController pwCheckController;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    handler = UserDataHandler();
    idController = TextEditingController();
    pwController = TextEditingController();
    pwCheckController = TextEditingController();
    nameController = TextEditingController();
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
                  signUpTextField('아이디를 입력하세요', idController, false),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: signUpTextField('비밀번호를 입력하세요', pwController, true),
                  ),
                  signUpTextField('비밀번호를 확인하세요', pwCheckController, true),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: signUpTextField('이름을 입력하세요', nameController, false),
                  ),
                  // 버튼, buttons
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

  signCheck() async {
    int idDuplication = await handler.signUpCheckUser(idController.text.trim());
    FocusScope.of(context).unfocus();
    if (idController.text.trim().isNotEmpty &&
        pwController.text.trim().isNotEmpty &&
        pwCheckController.text.trim().isNotEmpty) {
      if (idDuplication >= 1) {
        errorSnackBar('아이디 중복');
        return;
      }
      if (pwController.text.trim() != pwCheckController.text.trim()) {
        errorSnackBar('비밀번호가 일치하지 않음');
        return;
      }
    } else {
      errorSnackBar('빈칸을 채워주세요');
      return;
    }

    // DB아이디 추가!@
    User user = User(
      id: idController.text.trim(),
      pw: pwController.text.trim(),
      name: nameController.text.trim(),
    );
    await handler.insertUser(user);
    int seq = await handler.selectSeq(idController.text.trim());
    await handler.insertInitCategory(seq);

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

  strTextField(String hintLabel, TextEditingController controller) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 52, 31, 148),
        labelText: hintLabel,
        labelStyle: const TextStyle(color: Colors.white),
      ),
    );
  }

  signUpTextField(
      String hintLabel, TextEditingController controller, bool isPw) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      obscureText: isPw,
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        filled: true,
        fillColor: const Color.fromARGB(255, 52, 31, 148),
        labelText: hintLabel,
        labelStyle: const TextStyle(color: Colors.white),
      ),
    );
  }
}
