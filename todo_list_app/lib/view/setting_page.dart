import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/view/login_page.dart';

class SettingPage extends StatefulWidget {
  final Function(ThemeMode) onChangeTheme;
  const SettingPage({super.key, required this.onChangeTheme});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                child: Row(
                  children: [
                    Text(
                      '설정',
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  widget.onChangeTheme(ThemeMode.dark);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  alignment: Alignment.centerLeft,
                  fixedSize: Size.fromWidth(200)
                ),
                child: const Text('Dark Theme'),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.onChangeTheme(ThemeMode.light);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  foregroundColor: Theme.of(context).colorScheme.onTertiary,
                ),
                child: const Text('Light Theme'),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.onChangeTheme(ThemeMode.system);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: const Text('시스템 설정(자동)'),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.offAll(
                    const LoginPage(),
                    duration: const Duration(milliseconds: 100),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: const Text('로그아웃'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
