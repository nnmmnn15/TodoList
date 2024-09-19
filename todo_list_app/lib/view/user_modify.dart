import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_list_app/model/user.dart';
import 'package:todo_list_app/view/user_password_change.dart';
import 'package:todo_list_app/vm/user_data_handler.dart';

class UserModify extends StatefulWidget {
  const UserModify({super.key});

  @override
  State<UserModify> createState() => _UserModifyState();
}

class _UserModifyState extends State<UserModify> {
  // Property
  XFile? imageFile;
  final ImagePicker picker = ImagePicker();
  final UserDataHandler handler = UserDataHandler();

  late User user;
  late bool isReady;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    isReady = false;
    nameController = TextEditingController();

    getData();
  }

  getData() async {
    List<User> userData = await handler.queryUser();
    user = userData[0];
    isReady = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber[100],
        appBar: AppBar(
          title: const Text('회원정보 수정'),
          backgroundColor: const Color.fromARGB(255, 23, 7, 96),
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
        body: isReady
            ? Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage: user.profile == null
                                ? const AssetImage('images/login.png')
                                : MemoryImage(user.profile!),
                            radius: 80,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              onPressed: () =>
                                  getImageFromDevice(ImageSource.gallery),
                              icon: const Icon(
                                Icons.image,
                                size: 32,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                            child: Text(
                              '이름',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  popName();
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.edit,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(
                          () => const UserPasswordChange(),
                          arguments: user,
                        );
                      },
                      child: Text(
                        '비밀번호 변경',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 18),
                      ),
                    )
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }

  // --- Functions ---
  getImageFromDevice(imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile == null) {
      imageFile = null;
    } else {
      imageFile = XFile(pickedFile.path);
      File imageFile1 = File(imageFile!.path);
      Uint8List getImage = await imageFile1.readAsBytes();
      user.profile = getImage;

      await handler.updateUserImage(user);
    }
    setState(() {});
  }

  popName() {
    Get.dialog(
      AlertDialog(
        title: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const Text('이름 변경'),
        ),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            hintText: '변경할 이름을 작성해주세요',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              user.name = nameController.text.trim();
              await handler.updateUserName(user);
              nameController.text = '';
              setState(() {});
              Get.back();
            },
            child: const Text('변경하기'),
          ),
        ],
      ),
    );
  }
} // End
