import 'package:flutter/material.dart';
import 'package:nonogram_puzzle/class/stage_data_class.dart';
import 'package:nonogram_puzzle/main.dart';
import '../stage.dart';

void gameOverDialog(context, StageData stageData) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        //Dialog Main Title
        title: const Column(
          children: <Widget>[
            Text("게임 오버"),
          ],
        ),
        //
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "실패하였습니다.",
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => GameBoard(deliveryData:stageData)),
                      (route) => false,
                );
              },
              child: const Text("재시작")),
          TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => TestScreen()),
                      (route) => false,
                );
              },
              child: const Text("메인메뉴")),
        ],
      );
    },
  );
}

void gameClearDialog(context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        //Dialog Main Title
        title: const Column(
          children: <Widget>[
            Text("게임 클리어!"),
          ],
        ),
        //
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "성공하였습니다.",
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => TestScreen()),
                      (route) => false,
                );
              },
              child: const Text("메인메뉴")),
          TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => TestScreen()),
                      (route) => false,
                );
              },
              child: const Text("다음맵으로")),
        ],
      );
    },
  );
}