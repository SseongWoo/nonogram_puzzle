import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'file_save_load.dart';

//웹에서도 스크롤을 할 수 있게 해주는 클래스
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}

//스테이지로 넘어가는 데이터
class StageDataClass{
  late int number;
  late List<List<int>> stage;
  late SaveDataClass? saveData;
  late String level;

  StageDataClass(this.number, this.stage, this.level, this.saveData);
}