import 'package:flutter/material.dart';
import 'package:nonogram_puzzle/stage/global_variable.dart';
import '../../main_menu/color_list.dart';
import '../class_collection.dart';

//보드의 조각들의 색을 정하는 함수
BackgroundBlockClass getBackgroundColor(int checkNum, int colorNum) {
  Color color;
  Color mainColor = colorMap[mainBoardColor] ?? Colors.grey;
  ImageProvider? image;

  switch(checkNum){
    case 0 :
      color = mainColor;
      image = null;
      break;
    case 1 :
      color = mainColor;
      image = const AssetImage("assets/img/ban_gray.png");
      break;
    case 2 :
      color = mainColor;
      image = const AssetImage("assets/img/ban_red.png");
      break;
    case 3 :
      color = colorList[colorNum];
      image = null;
      break;
    default:
      color = mainColor;
      image = null;
      break;
  }
  return BackgroundBlockClass(color,image);
}
