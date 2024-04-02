import 'package:flutter/material.dart';

import '../class/stage_number.dart';

// 왼쪽 숫자보드의 숫자를 배치하여 처리하는 함수
List<Widget> initializeLeftBoard(int stageSize, int currentRow, double bodySize, List<LineNumClass>leftBoardData) {
  Color containerColor;
  List<int> positions = [];
  List<bool> check = [];
  List <Widget>newLeftBoard = List.filled(stageSize, Container());
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
      containerColor = Colors.blue;
    } else {
      containerColor = Colors.blueGrey;
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
                children:
                buildTextSpan(positions, bodySize, "Col", check))));
  }

  return newLeftBoard;
}

// 위쪽 숫자보드의 숫자를 배치하여 처리하는 함수
List<Widget> initializeTopBoard(int stageSize, int currentCol, double bodySize, List<LineNumClass>topBoardData) {
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
      containerColor = Colors.blue;
    } else {
      containerColor = Colors.blueGrey;
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
                children:
                buildTextSpan(positions, bodySize, "Row", check))));
  }

  return newTopBoard;
}

// 보드의 가로줄의 숫자를 숫자보드에 표시하기 위해 처리하는 함수
List<LineNumClass> settingLeftBoard(int stageSize, List<List<int>> stageDataList) {
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
List<LineNumClass> settingTopBoard(int stageSize, List<List<int>> stageDataList) {
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