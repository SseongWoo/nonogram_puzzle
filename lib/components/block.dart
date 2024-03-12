import 'package:flutter/material.dart';

class BoardBlock extends StatelessWidget {
  final int backgroundColor;
  final Color blockColor;
  final double top, bottom, left, right;

  const BoardBlock(
      {super.key,
      required this.backgroundColor,
      required this.blockColor,
      required this.top,
      required this.bottom,
      required this.left,
      required this.right});

  Color colorSelect(int bgColor){
    switch(bgColor){
      case 0:
        return Colors.grey;
      case 1:
        return Colors.black;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: colorSelect(backgroundColor),
          border: Border(
            top: BorderSide(
              color: blockColor,
              width: top,
            ),
            bottom: BorderSide(
              color: blockColor,
              width: bottom,
            ),
            left: BorderSide(
              color: blockColor,
              width: left,
            ),
            right: BorderSide(
              color: blockColor,
              width: right,
            ),
          ),
      ),
    );
  }
}
