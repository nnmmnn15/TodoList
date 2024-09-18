import 'package:flutter/material.dart';

class ConvertColor {
  Color strToColor(String color) {
    switch (color) {
      case '빨강':
        return const Color.fromRGBO(229, 115, 115, 1);
      case '하늘':
        return const Color.fromRGBO(187, 222, 251, 1);
      case '주황':
        return const Color.fromRGBO(255, 224, 178, 1);
      case '보라':
        return const Color.fromRGBO(225, 190, 231, 1);
      case '초록':
        return const Color.fromRGBO(200, 230, 201, 1);
      case '회색':
        return Colors.grey;
      case '진보라':
        return const Color.fromRGBO(149, 117, 205, 1);
      case '분홍':
        return const Color.fromRGBO(248, 187, 208, 1);
      default:
        return const Color.fromARGB(0, 255, 255, 255);
    }
  }

  String colorToStr(Color color) {
    switch (color) {
      case const Color.fromRGBO(229, 115, 115, 1):
        return '빨강';
      case const Color.fromRGBO(187, 222, 251, 1):
        return '하늘';
      case const Color.fromRGBO(255, 224, 178, 1):
        return '주황';
      case const Color.fromRGBO(225, 190, 231, 1):
        return '보라';
      case const Color.fromRGBO(200, 230, 201, 1):
        return '초록';
      case Colors.grey:
        return '회색';
      case const Color.fromRGBO(149, 117, 205, 1):
        return '진보라';
      case const Color.fromRGBO(248, 187, 208, 1):
        return '분홍';
      default:
        return '오류';
    }
  }
}
