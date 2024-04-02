import 'package:flutter/material.dart';

Drawer stageSettingMenu(context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          currentAccountPicture: CircleAvatar(),
          accountName: Text('yongho'),
          accountEmail: null,
          onDetailsPressed: () {
            print('arrow is clicked');
          },
        ),
        ListTile(
          title: Text('메뉴 항목 1'),
          onTap: () {
            // 메뉴 항목 1을 클릭했을 때 실행되는 함수
            Navigator.pop(context); // 메뉴 닫기
          },
        ),
        ListTile(
          title: Text('메뉴 항목 2'),
          onTap: () {
            // 메뉴 항목 2을 클릭했을 때 실행되는 함수
            Navigator.pop(context); // 메뉴 닫기
          },
        ),
      ],
    ),
  );
}
