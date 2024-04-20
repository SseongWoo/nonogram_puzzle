import 'package:flutter/material.dart';
import '../../main_menu/color_list.dart';
import '../class_collection.dart';
import '../global_variable.dart';

// 왼쪽 숫자보드의 숫자를 배치하여 처리하는 함수
List<Widget> initializeLeftBoard() {
  Color containerColor;
  List<int> positions = [];
  List<bool> check = [];
  List<Widget> newLeftBoard = List.filled(stageSize, Container());
  for (int index = 0; index < stageSize; index++) {
    positions = leftBoardData
        .where((lineNum) => lineNum.line == index)
        .map((lineNum) => lineNum.number)
        .toList();
    check = leftBoardData
        .where((lineNum) => lineNum.line == index)
        .map((lineNum) => lineNum.check)
        .toList();
    if (positions.isEmpty) {
      positions.add(0);
      check.add(true);
    }
    if (index == currentRow) {
      containerColor = colorMap[cursorColor] ?? Colors.blue;
    } else {
      containerColor = colorMap[sideColor] ?? Colors.blueGrey;
    }

    newLeftBoard[index] = Container(
        height: (bodySize * 3) / stageSize,
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: containerColor,
          border: const Border(
            top: BorderSide(width: 0.5),
            bottom: BorderSide(width: 0.5),
          ),
        ),
        child: RichText(
            text: TextSpan(
                children: buildTextSpan(positions, bodySize, "Col", check))));
  }
  return newLeftBoard;
}

// 위쪽 숫자보드의 숫자를 배치하여 처리하는 함수
List<Widget> initializeTopBoard() {
  Color containerColor;
  List<int> positions = [];
  List<bool> check = [];
  List<Widget> newTopBoard = List.filled(stageSize, Container());
  for (int index = 0; index < stageSize; index++) {
    positions = topBoardData
        .where((lineNum) => lineNum.line == index)
        .map((lineNum) => lineNum.number)
        .toList();
    check = topBoardData
        .where((lineNum) => lineNum.line == index)
        .map((lineNum) => lineNum.check)
        .toList();
    if (positions.isEmpty) {
      positions.add(0);
      check.add(true);
    }

    if (index == currentCol) {
      containerColor = colorMap[cursorColor] ?? Colors.blue;
    } else {
      containerColor = colorMap[sideColor] ?? Colors.blueGrey;
    }
    newTopBoard[index] = Container(
        width: (bodySize * 3) / stageSize,
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          color: containerColor,
          border: const Border(
            left: BorderSide(width: 0.5),
            right: BorderSide(width: 0.5),
          ),
        ),
        child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                children: buildTextSpan(positions, bodySize, "Row", check))));
  }
  return newTopBoard;
}

// 보드의 가로줄의 숫자를 숫자보드에 표시하기 위해 처리하는 함수
List<LineNumClass> settingLeftBoard() {
  List<LineNumClass> newLeftBoardData = [];
  LineNumClass lineNum;
  List<int> position;
  int sum, count;
  for (int row = 0; row < stageSize; row++) {
    sum = 0;
    count = 0;
    position = [];
    for (int col = 0; col < stageSize; col++) {
      if (col == stageSize - 1) {
        if (stageDataList[row][col] != 0) {
          position.add(col);
          sum++;
        }
        if (sum != 0) {
          lineNum = LineNumClass(row, count, sum, position, false);
          newLeftBoardData.add(lineNum);
          position = [];
        }
      } else if (stageDataList[row][col] == 0 && sum != 0) {
        lineNum = LineNumClass(row, count, sum, position, false);
        newLeftBoardData.add(lineNum);
        position = [];
        count++;
        sum = 0;
      } else if (stageDataList[row][col] != 0) {
        position.add(col);
        sum++;
      }
    }
  }
  return newLeftBoardData;
}

// 보드의 세로줄의 숫자를 숫자보드에 표시하기 위해 처리하는 함수
List<LineNumClass> settingTopBoard() {
  List<LineNumClass> newTopBoardData = [];
  LineNumClass lineNum;
  List<int> position;
  int sum, count;
  for (int col = 0; col < stageSize; col++) {
    sum = 0;
    count = 0;
    position = [];
    for (int row = 0; row < stageSize; row++) {
      if (row == stageSize - 1) {
        if (stageDataList[row][col] != 0) {
          position.add(row);
          sum++;
        }
        if (sum != 0) {
          lineNum = LineNumClass(col, count, sum, position, false);
          newTopBoardData.add(lineNum);
          position = [];
        }
      } else if (stageDataList[row][col] == 0 && sum != 0) {
        lineNum = LineNumClass(col, count, sum, position, false);
        newTopBoardData.add(lineNum);
        position = [];
        count++;
        sum = 0;
      } else if (stageDataList[row][col] != 0) {
        position.add(row);
        sum++;
      }
    }
  }
  return newTopBoardData;
}

//사이드 보드에 숫자데이터를 표시하기 위해 리스트에 있는 데이터를 쪼개서 TextSpan리스트에 넣는 함수
List<TextSpan> buildTextSpan(
    List<int> list, double size, String checkRowCol, List<bool> correct) {
  List<TextSpan> textSpans = [];
  String plusString;
  if (checkRowCol == "Row") {
    plusString = "\n";
  } else {
    plusString = " ";
  }

  for (int i = 0; i < list.length; i++) {
    if (list.length - 1 == i) plusString = "";
    textSpans.add(
      TextSpan(
        text: "${list[i]}$plusString",
        style: _getStyleForVariable(list[i], size, correct[i]),
      ),
    );
  }
  return textSpans;
}

//사이드 보드의 숫자데이터를 10보다 클경우 노란색으로 작을경우 흰색, 정답을 맞춘 구간이면 회색으로 표현하는 함수
TextStyle _getStyleForVariable(int index, double size, bool correct) {
  if (correct) {
    return TextStyle(color: Colors.grey, fontSize: size / 8);
  } else {
    if (index < 10) {
      return TextStyle(color: Colors.white, fontSize: size / 8);
    } else {
      return TextStyle(color: Colors.yellowAccent, fontSize: size / 8);
    }
  }
}

// 생명이 몇개 남아있는지 표시해주는 함수
void initializeLifeBoard() {
  List<Widget> newLife = [];
  for (int i = 0; i < life; i++) {
    newLife.add(const Icon(
      Icons.favorite,
      color: Colors.blue,
    ));
  }
  lifeList = newLife;
}
