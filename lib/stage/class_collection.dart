import 'package:flutter/material.dart';

// 보드 조각의 색과 이미지를 가지는 클래스
class BackgroundBlockClass {
  Color backgroundColor;
  ImageProvider? backgroundImage;

  BackgroundBlockClass(this.backgroundColor, this.backgroundImage);
}

// 블럭의 외각선을 정하는 변수 클래스
class BorderSettingClass {
  double borderTop;
  double borderBottom;
  double borderLeft;
  double borderRight;

  BorderSettingClass(
      this.borderTop, this.borderBottom, this.borderLeft, this.borderRight);
}

//사이드 보드들의 데이터 클래스
class LineNumClass {
  int line;
  int count;
  int number;
  List<int> position;
  bool check;

  LineNumClass(this.line, this.count, this.number, this.position, this.check);

  @override
  String toString() {
    return 'LineNumClass(line: $line, count: $count, number: $number, position: $position check: $check)';
  }
}

// 메인보드의 원하는 피스타입의 갯수를 세기위해 사용되는 클래스
class UncheckedBoardListClass {
  late int row;
  late int col;

  UncheckedBoardListClass(this.row, this.col);
}
