import 'dart:ui';

import 'package:flutter/material.dart';

class BackgroundBlockClass{
  Color backgroundColor;
  ImageProvider? backgroundImage;

  BackgroundBlockClass(this.backgroundColor, this.backgroundImage);
}

BackgroundBlockClass getBackgroundColor(int checkNum, int colorNum) {
  Color color;
  ImageProvider? image;

  Color boardColor(){
    Color blockColor;
    switch (colorNum) {
      case 0:
        blockColor = Colors.grey;
        break;
      case 1:
        blockColor = Colors.red;
        break;
      case 2:
        blockColor = Colors.orange;
        break;
      case 3:
        blockColor = Colors.yellow;
        break;
      case 4:
        blockColor = Colors.green;
        break;
      default:
        blockColor = Colors.grey;
        break;
    }
    return blockColor;
  }

  switch(checkNum){
    case 0 :
      color = Colors.grey;
      image = null;
      break;
    case 1 :
      color = Colors.grey;
      image = const AssetImage("assets/img/ban_gray.png");
      break;
    case 2 :
      color = Colors.grey;
      image = const AssetImage("assets/img/ban_red.png");
      break;
    case 3 :
      color = boardColor();
      image = null;
      break;
    default:
      color = Colors.grey;
      image = null;
      break;
  }
  return BackgroundBlockClass(color,image);
}
