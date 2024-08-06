import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list_app/view/login_page.dart';
import 'package:todo_list_app/view/setting_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light; // 기기의 초기값

  _changeThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    setState(() {});
  }

  static const seedColor = Colors.deepPurple;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      themeMode: _themeMode,
      darkTheme: ThemeData(
        // dark mode
        brightness: Brightness.dark,
        useMaterial3: true,
        colorSchemeSeed: seedColor,
      ),
      theme: ThemeData(
        // light mode
        brightness: Brightness.light,
        useMaterial3: true,
        colorSchemeSeed: seedColor,
      ),
      home: const LoginPage(),
      getPages: [
        GetPage(
          name: '/setting',
          page: () => SettingPage(onChangeTheme: _changeThemeMode),
        ),
      ],
    );
  }
}
