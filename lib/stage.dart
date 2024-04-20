library board_common_data;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nonogram_puzzle/main_menu/color_list.dart';
import 'package:nonogram_puzzle/main_menu/menu_class.dart';
import 'package:nonogram_puzzle/stage/button_circle.dart';
import 'package:nonogram_puzzle/stage/global_variable.dart';
import 'package:nonogram_puzzle/stage/save_load.dart';
import 'package:nonogram_puzzle/stage/setting.dart';
import 'stage/other_function.dart';
import 'stage/board/check_board.dart';
import 'stage/key_control.dart';
import 'stage/board/mainboard.dart';
import 'stage/board/sideboard.dart';


class GameBoard extends StatefulWidget {
  final StageDataClass deliveryData; // 외부에서 가져온 데이터들의 클래스데이터

  const GameBoard({super.key, required this.deliveryData});

  @override
  State<GameBoard> createState() => GameBoardState();
}

class GameBoardState extends State<GameBoard> {
  @override
  void initState() {
    super.initState();
    deliveryDataList = widget.deliveryData;
    stageNumber = deliveryDataList.number;
    stageDataList = deliveryDataList.stage;
    stageSize = stageDataList.length;
    stageSaveData = deliveryDataList.saveData;
    level = deliveryDataList.level;
    _timer();
    if (stageSaveData != null) {
      stageCheck = stageSaveData!.stageCheck;
      life = stageSaveData!.life;
      hint = stageSaveData!.hint;
      elapsedTime += stageSaveData!.time;
    } else {
      stageCheck = List.generate(
        stageSize,
        (index) => List<int>.filled(stageSize, 0),
      );
      life = 5;
      hint = 5;
    }
    topBoardData = settingTopBoard();
    leftBoardData = settingLeftBoard();
    mainBoard = initializeMainBoard();
    initializeLifeBoard();
    checkMainBoard();
  }

  @override
  void dispose() {
    stopwatch.reset();
    timeSwitch.cancel();
    stopwatchText = "0초";
    super.dispose();
  }

  void _timer() {
    elapsedTime = stopwatch.elapsed;
    stopwatch.start();
    timeSwitch = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsedTime += const Duration(seconds: 1);
        stopwatchText = formatTime(elapsedTime);
      });
    });
  }

  void inputKeyEvent(RawKeyEvent? event) {
    setState(() {
      keyEvent(event);
    });
  }
  void inputMouseEvent(String state) {
    if(mouseEnable){
      setState(() {
        mouseButtonClick(state);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    contextData = context;
    Size screenSize = MediaQuery.of(context).size;
    double windowSize = (getScreeningSize(screenSize));
    double appbarSize = MediaQuery.of(context).padding.top + kToolbarHeight;
    bodySize = (windowSize - appbarSize) / 4;
    topBoard = initializeTopBoard();
    leftBoard = initializeLeftBoard();
    settingPosition = -(bodySize * 2);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        leading: IconButton(
            onPressed: () {
              stageSave(stageNumber, stageCheck, life, hint, elapsedTime,false);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  settingVisible = !settingVisible;
                });
              },
              icon: const Icon(Icons.settings))
        ],
        title: Text(
          "Stage$stageNumber",
          style: TextStyle(fontSize: bodySize / 7),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Stack(children: [
        Center(
          child: GestureDetector(
            onSecondaryTap: () {
              setState(() {
                choiceButton = !choiceButton;
              });
            },
            child: MyKeyboardListener(
              onKeyEvent: inputKeyEvent,
              child: SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                              height: bodySize,
                              width: bodySize,
                              color: colorMap[sideColor],
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: bodySize / 4,
                                    child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                          "Life",
                                          style: TextStyle(
                                              fontSize: (bodySize * 12) / 100),
                                        )),
                                  ),
                                  SizedBox(
                                      height: bodySize / 4,
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: lifeList,
                                        ),
                                      )),
                                  SizedBox(
                                    height: bodySize / 4,
                                    child: Text(
                                      "Time",
                                      style: TextStyle(
                                          fontSize: (bodySize * 12) / 100),
                                    ),
                                  ),
                                  SizedBox(
                                    height: bodySize / 4,
                                    child: Text(
                                      stopwatchText,
                                      style: TextStyle(
                                          fontSize: (bodySize * 10) / 100),
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: bodySize,
                            width: bodySize * 3,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: stageSize,
                              itemBuilder: (context, index) {
                                return topBoard[index];
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            height: bodySize * 3,
                            width: bodySize,
                            child: ListView.builder(
                              itemCount: stageSize,
                              itemBuilder: (context, index) {
                                return leftBoard[index];
                              },
                            ),
                          ),
                          SizedBox(
                            height: bodySize * 3,
                            width: bodySize * 3,
                            child: GridView.builder(
                              itemCount: stageSize * stageSize,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: stageSize),
                              itemBuilder: (context, index) {
                                int row = index ~/ stageSize;
                                int col = index % stageSize;
                                return MouseRegion(
                                  onEnter: (event) {
                                    if(mouseEnable) {
                                      setState(() {
                                        mouseHoverControl(row, col);
                                      });
                                    }
                                  },
                                  child: GestureDetector(
                                      onTapDown: (details) =>
                                          inputMouseEvent("DOWN"),
                                      onPanStart: (details) =>
                                          inputMouseEvent("DOWN"),
                                      onTapUp: (details) =>
                                          inputMouseEvent("UP"),
                                      onPanEnd: (details) =>
                                          inputMouseEvent("UP"),
                                      child: mainBoard[row][col]),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 10,
          bottom: 10,
          child: Container(
            height: (bodySize / 2) - (bodySize / 30),
            width: bodySize - (bodySize / 20),
            decoration: BoxDecoration(
              color: Colors.brown,
              borderRadius: BorderRadius.circular(bodySize / 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ChoiceButton(
                  buttonSize: bodySize,
                  icon: Icons.radio_button_off,
                  iconSize: (bodySize * 15) / 100,
                  onPressed: choiceButton
                      ? null
                      : () {
                          mouseButtonDisabled(false);
                        },
                ),
                ChoiceButton(
                  buttonSize: bodySize,
                  icon: Icons.close,
                  iconSize: (bodySize * 15) / 100,
                  onPressed: choiceButton
                      ? () {
                          mouseButtonDisabled(true);
                        }
                      : null,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 40,
          bottom: (bodySize * 55) / 100,
          child: SizedBox(
            height: (bodySize * 40) / 100,
            width: (bodySize * 40) / 100,
            child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    getHint();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  disabledBackgroundColor: Colors.lightBlue,
                  shape: const CircleBorder(),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Text(
                      "?",
                      style: TextStyle(fontSize: (bodySize * 20) / 100),
                      textAlign: TextAlign.center,
                    ),
                    Positioned(
                      top: -(bodySize * 10) / 100,
                      right: -(bodySize * 15) / 100,
                      child: Container(
                        height: (bodySize * 15) / 100,
                        width: (bodySize * 15) / 100,
                        decoration: const BoxDecoration(
                            color: Colors.red, shape: BoxShape.circle),
                        child: Center(
                          child: Text(
                            "$hint",
                            style: TextStyle(
                                fontSize: (bodySize * 10) / 100,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ),
        AnimatedPositioned(
          top: 0,
          right: settingVisible ? 0 : -(bodySize * 4),
          curve: Curves.easeInOutQuint,
          duration: const Duration(milliseconds: 300),
          child: const SettingMenu(),
        ),
      ]),
    );
  }
}
