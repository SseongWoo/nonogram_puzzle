import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nonogram_puzzle/stage/class_collection.dart';
import '../main_menu/file_save_load.dart';
import '../main_menu/menu_class.dart';

late StageDataClass deliveryDataList;
dynamic contextData;

List<List<Widget?>> mainBoard = []; // 화면에 보이게 될 메인 보드 이중 리스트
List<Widget> topBoard = []; // 화면에 보이게 될 상단 보드 리스트
List<Widget> leftBoard = []; // 화면에 보이게 될 왼쪽 보드 리스트
List<Widget> lifeList = []; // 생명이 몇개 남았는지 화면에 보여주기 위한 리스트

// 0 : 기본상태(회색) 1 : 사용자가 x를 누른 상태(회색X 이미지 생성) 2 : 사용자가 정답을 틀린 상태(빨간색 X이미지 생성) 3 : 사용자가 정답을 맞춘 상태
// 사용자가 해당 블록에 행동한 기록을 가지고 있는 이중 리스트
List<List<int>> stageCheck = [];
List<List<int>> stageDataList = []; // 외부에서 가져온 숫자로 구성된 데이터로 색 정보를 가지고 있는 이중 리스트
List<LineNumClass> topBoardData = []; //보드 상단에 위치한 보드의 숫자 데이터를 보여주는 리스트
List<LineNumClass> leftBoardData = []; //보드 좌측에 위치한 보드의 숫자 데이터를 보여주는 리스트

int stageSize = 0; //보드의 크기를 정하기 위해 외부에서 가져온 변수
int stageNumber = 0; //해당 스테이지의 번호를 외부에서 가져온 변수
double bodySize = 0.0; //해당 화면의 Scaffold의 body의 크기를 가지고 있는 변수

late int life; // 해당 보드 게임의 생명 개수
late int hint; // 해당 보드 게임의 힌트 개수

int currentRow = 0; //현재 커서의 row 위치 변수
int currentCol = 0; //현재 커서의 col 위치 변수

double selectBorder = 2.0; // 커서의 외곽선 두께 변수

bool zKey = false; // z키가 눌려있는지 확인하는 변수
bool xKey = false; // x키가 눌려있는지 확인하는 변수
bool choiceButton = true; // 마우스로 조작할 때 좌클릭으로 z,x버튼을 사용할수 있도록 우클릭으로 조작하는 변수

Random random = Random(); // 랜덤 변수
Stopwatch stopwatch = Stopwatch(); // 시간을 설정하기 위한 시간 변수
String stopwatchText = "0초"; // 시간을 화면에 표시하는 변수
late Timer timeSwitch; // 타이머 변수
late Duration elapsedTime;
late SaveDataClass? stageSaveData;

bool settingVisible = false; // 설정 화면 on/off 변수
double settingPosition = 0; // 설정 화면 이동 애니메이션 포지션 변수
final player = AudioPlayer(); // 효과음을 재생하기 위한 플레이어
bool soundCheck = true; // 효과음 on/off 변수
bool mouseEnable = true; // 마우스 컨트롤 on/off 변수
double soundVolume = 50.0; // 효과음 볼륨 변수

String mainBoardColor = "grey";   //메인보드 색
String sideColor = "blueGrey";    //사이드보드 색
String cursorColor = "blue";      //커서 색
String level = "Nomal"; // 난이도
