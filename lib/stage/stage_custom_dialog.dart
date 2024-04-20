import 'package:flutter/material.dart';
import 'package:nonogram_puzzle/main_menu.dart';
import 'package:nonogram_puzzle/stage/global_variable.dart';
import '../stage.dart';
import 'other_function.dart';

// 게임오버시 나오는 다이얼로그
void gameOverDialog() {
  showDialog(
    context: contextData,
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
                timeEnd();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          GameBoard(deliveryData: deliveryDataList)),
                  (route) => false,
                );
              },
              child: const Text("재시작")),
          TextButton(
              onPressed: () {
                timeEnd();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainMenu()),
                  (route) => false,
                );
              },
              child: const Text("메인메뉴")),
        ],
      );
    },
  );
}

// 게임클리어시 나오는 다이얼로그
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
                timeEnd();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainMenu()),
                  (route) => false,
                );
              },
              child: const Text("확인")),
        ],
      );
    },
  );
}

// 힌트의 개수가 부족하거나 열려있지 않은 조각이 적을시 나타나는 다이얼로그
void hintDialog(context, bool numberHint) {
  String titleText = "메세지";
  String contentText = "";

  if (numberHint) {
    contentText = "힌트의 개수가 부족합니다.";
  } else {
    contentText = "정답이 너무 적어 힌트를 사용할 수 없습니다.";
  }

  showDialog(
    context: context,
    barrierDismissible: true, //바깥 영역 터치시 닫을지 여부 결정
    builder: ((context) {
      return AlertDialog(
        title: Text(titleText),
        content: Text(contentText),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); //창 닫기
            },
            child: const Text("확인"),
          ),
        ],
      );
    }),
  );
}

// 로딩 다이얼로그
void loadingDialog(int time) {
  showDialog(
    context: contextData,
    barrierDismissible: false, //바깥 영역 터치시 닫을지 여부 결정
    builder: ((context) {
      Future.delayed(Duration(seconds: time), () {
        Navigator.of(context).pop();
      });
      return const AlertDialog(
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          Center(
            child: SizedBox(
              child: CircularProgressIndicator(color: Colors.blue,),
            ),
          )
        ],
      );
    }),
  );
}
