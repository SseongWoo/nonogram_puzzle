import 'package:flutter/material.dart';

class BoardPiece extends StatelessWidget {
  final Color backgroundColor;
  final Color blockColor;
  final double top, bottom, left, right;
  final ImageProvider? img;

  const BoardPiece(
      {super.key,
      required this.backgroundColor,
      required this.blockColor,
      required this.top,
      required this.bottom,
      required this.left,
      required this.right,
      this.img});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
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
        image: img != null
            ? DecorationImage(image: img!)
            : null, // 이미지가 null이 아닌 경우에만 이미지 생성
      ),
    );
  }
}
