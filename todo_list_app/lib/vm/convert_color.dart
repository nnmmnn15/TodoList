import 'package:flutter/material.dart';

class ConvertColor {
  Color strToColor(String color) {
    switch (color) {
      case '빨강':
        return const Color.fromRGBO(255, 205, 210, 1);
      case '하늘':
        return const Color.fromRGBO(187, 222, 251, 1);
      default:
        return const Color.fromARGB(0, 255, 255, 255);
    }
  }

  String colorToStr(Color color) {
    switch (color) {
      case const Color.fromRGBO(255, 205, 210, 1):
        return '빨강';
      case const Color.fromRGBO(187, 222, 251, 1):
        return '하늘';
      default:
        return '오류';
    }
  }
}
