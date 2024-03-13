import 'package:flutter/material.dart';

double getScreeningSize(Size size) {
  double minSize = 600;

  if (size.width < size.height) {
    if (size.width > minSize) {
      return (size.width / 20).roundToDouble() * 20;
    }
    else{
      return minSize;
    }
  }
  else{
    if(size.height > minSize){
      return (size.height / 20).roundToDouble() * 20;
    }
    else{
      return minSize;
    }
  }
}