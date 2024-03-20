import 'package:flutter/material.dart';

class LineNumClass{
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

List<TextSpan> buildTextSpan(List<int> list, double size, String checkRowCol, List<bool> correct){
  List<TextSpan> textSpans = [];
  String plusString;
  if(checkRowCol == "Row"){
    plusString = "\n";
  }else{
    plusString = " ";
  }

  for(int i = 0; i < list.length; i++){
    if(list.length - 1 == i)plusString = "";
    textSpans.add(
      TextSpan(
        text: "${list[i]}$plusString",
        style: _getStyleForVariable(list[i], size, correct[i]),
      ),
    );
  }
  return textSpans;
}

TextStyle _getStyleForVariable(int index , double size, bool correct) {
  if(correct){
    return TextStyle(color: Colors.grey, fontSize: size / 8);
  }
  else{
    if(index < 10){
      return TextStyle(color: Colors.white, fontSize: size / 8);
    }
    else {
      return TextStyle(color: Colors.yellowAccent, fontSize: size / 8);
    }
  }
}