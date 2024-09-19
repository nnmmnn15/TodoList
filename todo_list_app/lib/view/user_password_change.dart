import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/model/user.dart';
import 'package:todo_list_app/vm/user_data_handler.dart';

class UserPasswordChange extends StatefulWidget {
  const UserPasswordChange({super.key});

  @override
  State<UserPasswordChange> createState() => _UserPasswordChangeState();
}

class _UserPasswordChangeState extends State<UserPasswordChange> {
  final UserDataHandler handler = UserDataHandler();

  late TextEditingController currentPwController;
  late TextEditingController pwController;
  late TextEditingController pwCheckController;

  User user = Get.arguments ?? '__';

  @override
  void initState() {
    super.initState();
    currentPwController = TextEditingController();
    pwController = TextEditingController();
    pwCheckController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.amber[100],
        appBar: AppBar(
          title: const Text('비밀번호 변경'),
          backgroundColor: const Color.fromARGB(255, 23, 7, 96),
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: pwTextField('현재 비밀번호를 입력하세요', currentPwController),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: pwTextField('새 비밀번호를 입력하세요', pwController),
                ),
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: pwTextField('새 비밀번호를 확인하세요', pwCheckController),
                ),
                ElevatedButton(
                  onPressed: () {
                    //
                    checkPw();
                  },
                  style:
                      ElevatedButton.styleFrom(fixedSize: const Size(100, 40)),
                  child: const Text('변경하기'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Functions ---
  pwTextField(String hintLabel, TextEditingController controller) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      obscureText: true,
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

  checkPw() async {
    int result =
        await handler.pwCheckUser(currentPwController.text.trim(), user.seq!);
    if (result == 0) {
      errorSnackBar('현재 비밀번호가 일치하지 않습니다');
      return;
    }

    if (pwController.text.trim() != pwCheckController.text.trim()) {
      errorSnackBar('새 비밀번호가 일치하지 않습니다');
      return;
    }

    user.pw = pwController.text.trim();
    await handler.updateUserPw(user);
    popDialog();
  }

  popDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('변경완료'),
        content: const Text('비밀번호가 변경되었습니다'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}
