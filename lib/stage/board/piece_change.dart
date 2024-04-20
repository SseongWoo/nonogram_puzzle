import 'package:flutter/material.dart';
import 'package:nonogram_puzzle/main_menu/color_list.dart';
import 'package:nonogram_puzzle/stage/board/piece.dart';
import 'package:nonogram_puzzle/stage/board/piece_border.dart';
import 'package:nonogram_puzzle/stage/board/piece_color.dart';
import '../global_variable.dart';
import '../class_collection.dart';

//보드 조각의 데이터를 교환해주는 함수 사용자 커서가 들어가거나 사용자가 선택하여 상태가 변경되는것을 처리
void boardPieceChange(int row, int col, bool check, bool img) {
  BackgroundBlockClass blockClass =
      getBackgroundColor(stageCheck[row][col], stageDataList[row][col]);
  BorderSettingClass borders = borderSetting(row, col, stageSize);
  ImageProvider? imageProvider;

  if (img) {
    imageProvider = const AssetImage("assets/img/ban_gray.png");
  } else {
    imageProvider = blockClass.backgroundImage;
  }
  if (check) {
    mainBoard[row][col] = BoardPiece(
      backgroundColor: blockClass.backgroundColor,
      blockColor: colorMap[cursorColor] ?? Colors.blueAccent,
      top: selectBorder,
      bottom: selectBorder,
      left: selectBorder,
      right: selectBorder,
      img: imageProvider,
    );
  } else {
    mainBoard[row][col] = BoardPiece(
      backgroundColor: blockClass.backgroundColor,
      blockColor: Colors.black,
      top: borders.borderTop,
      bottom: borders.borderBottom,
      left: borders.borderLeft,
      right: borders.borderRight,
      img: imageProvider,
    );
  }
}
