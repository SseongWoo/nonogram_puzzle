import 'package:flutter/material.dart';
import '../class_collection.dart';
import '../global_variable.dart';
import 'piece.dart';
import 'piece_border.dart';
import 'piece_color.dart';

// 메인 보드를 초기 설정하는 함수
List<List<Widget?>> initializeMainBoard() {
  Color borderColor;
  BorderSettingClass borders = BorderSettingClass(0.0, 0.0, 0.0, 0.0);
  BackgroundBlockClass blockClass;
  List<List<Widget?>> newMainBoard = List.generate(
      stageSize,
          (index) => List.generate(
        stageSize,
            (index) => null,
      ));
  for (int row = 0; row < stageSize; row++) {
    for (int col = 0; col < stageSize; col++) {
      blockClass =
          getBackgroundColor(stageCheck[row][col], stageDataList[row][col]);
      borders = borderSetting(row, col, stageSize);
      borderColor = Colors.black;
      if (row == currentRow && col == currentCol) {
        newMainBoard[currentRow][currentCol] = BoardPiece(
            backgroundColor: blockClass.backgroundColor,
            blockColor: Colors.blueAccent,
            top: selectBorder,
            bottom: selectBorder,
            left: selectBorder,
            right: selectBorder,
            img: blockClass.backgroundImage);
      } else {
        newMainBoard[row][col] = BoardPiece(
          backgroundColor: blockClass.backgroundColor,
          blockColor: borderColor,
          top: borders.borderTop,
          bottom: borders.borderBottom,
          left: borders.borderLeft,
          right: borders.borderRight,
          img: blockClass.backgroundImage,
        );
      }
    }
  }
 return newMainBoard;
}

// 메인보드의 원하는 블록타입의 갯수를 세는 함수
List<UncheckedBoardListClass>? uncheckedBoardList(int kind){
  List<UncheckedBoardListClass> newUncheckedBoardWidgetList = [];
  for(int row = 0; row < stageCheck.length; row++){
    for(int col = 0; col < stageCheck.length; col++){
      if(stageCheck[row][col] == kind && stageDataList[row][col] != 0){
        newUncheckedBoardWidgetList.add(UncheckedBoardListClass(row, col));
      }
    }
  }
  if(newUncheckedBoardWidgetList.length > 2){
    return newUncheckedBoardWidgetList;
  }
  else{
    return null;
  }
}