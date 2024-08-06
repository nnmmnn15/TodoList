import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/model/user_data.dart';
import 'package:todo_list_app/model/user_list.dart';

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
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            TextField(
              controller: pwCheckController,
              obscureText: true,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.grey,
                labelText: '비밀번호를 확인하세요',
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () => signCheck(),
              style: ElevatedButton.styleFrom(fixedSize: const Size(100, 40)),
              child: const Text('회원가입'),
            ),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(fixedSize: const Size(100, 40)),
              child: const Text('뒤로가기'),
            ),
          ],
        ),
      ),
    );
  }

  signCheck() {
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
