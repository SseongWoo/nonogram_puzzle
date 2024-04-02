import 'package:flutter/material.dart';

import '../class/stage_board_block.dart';
import '../class/stage_board_block_border_setting.dart';
import '../class/stage_board_block_color.dart';

// 메인 보드를 초기 설정하는 함수
List<List<Widget?>> initializeMainBoard(int stageSize, List<List<int>> stageCheck, List<List<int>> stageDataList, int currentRow, int currentCol, double selectBorder) {
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
      if (row == 0 && col == 0) {
        newMainBoard[currentRow][currentCol] = BoardBlock(
            backgroundColor: blockClass.backgroundColor,
            blockColor: Colors.blueAccent,
            top: selectBorder,
            bottom: selectBorder,
            left: selectBorder,
            right: selectBorder,
            img: blockClass.backgroundImage);
      } else {
        newMainBoard[row][col] = BoardBlock(
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

//stageSize,stageCheck,stageDataList,currentRow,currentCol,selectBorder