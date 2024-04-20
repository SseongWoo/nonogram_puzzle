import 'package:flutter/material.dart';
import '../stage.dart';
import 'menu_class.dart';

//메인메뉴에서 스테이지를 선택했을때 저장된 데이터가 있을때 띄워지는 다이얼로그
void stageSelectDialog(context, StageDataClass data) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        title: const Column(
          children: <Widget>[
            Text("불러오기"),
          ],
        ),
        //
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "진행중인 게임이 있습니다.\n이어서 하시겠습니까?",
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameBoard(deliveryData: data),
                  ),
                );
              },
              child: const Text("예")),
          TextButton(
              onPressed: () {
                data.saveData = null;
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameBoard(deliveryData: data),
                  ),
                );
              },
              child: const Text("아니오")),
        ],
      );
    },
  );
}

//메인메뉴에서 스테이지를 선택했을때 클리한 스테이지일때 띄워지는 다이얼로그
void stageSelectDialog2(context, StageDataClass data) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        title: const Column(
          children: <Widget>[
            Text("메세지"),
          ],
        ),
        //
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "이미 클리어한 지역입니다.\n다시 하시겠습니까?",
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameBoard(deliveryData: data),
                  ),
                );
              },
              child: const Text("예")),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("아니오")),
        ],
      );
    },
  );
}

//메인메뉴에서 저장버튼을 눌렀을때 저장될 데이터가 없을경우 띄어지는 다이얼로그
void fileSaveDialog(context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        title: const Column(
          children: <Widget>[
            Text("메세지"),
          ],
        ),
        //
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "저장할 데이터가 없습니다.",
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("확인")),
        ],
      );
    },
  );
}