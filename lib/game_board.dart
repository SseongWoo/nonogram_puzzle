import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:nonogram_puzzle/components/block.dart';
import 'package:nonogram_puzzle/components/border_setting.dart';
import 'package:nonogram_puzzle/components/buttonData.dart';
import 'package:nonogram_puzzle/components/stage_data_class.dart';
import 'package:nonogram_puzzle/components/stage_number.dart';
import 'components/block_color.dart';
import 'components/key_control.dart';
import 'components/stage_size.dart';

//라이프, 승리이벤트, 메뉴버튼, 시간 혹은 점수, 마우스 조작

class GameBoard extends StatefulWidget {
  final StageData deliveryData;

  const GameBoard({super.key, required this.deliveryData});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late List<List<Widget?>> mainBoard;
  late List<List<int>> stageDataList;

  // 0 : 기본상태(회색) 1 : 사용자가 x를 누른 상태(회색X 이미지 생성) 2 : 사용자가 정답을 틀린 상태(빨간색 X이미지 생성) 3 : 사용자가 정답을 맞춘 상태
  late List<List<int>> stageCheck;

  late int stageSize;
  late int stageNumber;
  late double bodySize;

  List<LineNumClass> newNumRow = [];
  List<LineNumClass> newNumCol = [];

  late List<Widget> newRow;
  late List<Widget> newCol;

  int currentRow = 0;
  int currentCol = 0;

  int selectedRow = 0;
  int selectedCol = 0;

  double selectBorder = 2.0;
  late double containerSize;

  bool zKey = false;
  bool xKey = false;
  bool choiceButton = true;

  @override
  void initState() {
    super.initState();
    stageNumber = widget.deliveryData.number;
    stageDataList = widget.deliveryData.stage;
    stageSize = widget.deliveryData.hw;
    stageCheck = List.generate(
      stageSize,
      (index) => List<int>.filled(stageSize, 0),
    );
    _newGetLineNumRow();
    _newGetLineNumCol();
    _initializeMainBoard();
    _checkBoardLine();
  }

  void saveData(){

  }
  void loadData(){

  }

  void cursor(int row, int col, bool check, bool img) {
    setState(() {
      BackgroundBlockClass blockClass =
          getBackgroundColor(stageCheck[row][col], stageDataList[row][col]);
      BorderSettingClass borders = borderSetting(row, col, stageSize);
      ImageProvider? imageProvider;

      if (img) {
        imageProvider = const AssetImage("assets/img/ban_gray.png");
      } else {
        imageProvider = blockClass.backgroundImage;
      }
      if (check) {
        mainBoard[row][col] = BoardBlock(
          backgroundColor: blockClass.backgroundColor,
          blockColor: Colors.blueAccent,
          top: selectBorder,
          bottom: selectBorder,
          left: selectBorder,
          right: selectBorder,
          img: imageProvider,
        );
      } else {
        mainBoard[row][col] = BoardBlock(
          backgroundColor: blockClass.backgroundColor,
          blockColor: Colors.black,
          top: borders.borderTop,
          bottom: borders.borderBottom,
          left: borders.borderLeft,
          right: borders.borderRight,
          img: imageProvider,
        );
      }
    });
  }

  void handleKeyEvent(RawKeyEvent? event) {
    // 키 이벤트 처리
    final key = event?.data.logicalKey;
    if (event is RawKeyDownEvent) {
      if (key == LogicalKeyboardKey.keyZ) {
        zKey = true;
        xKey = false;
        setState(() {
          choiceButton = true;
        });
      }
      if (key == LogicalKeyboardKey.keyX) {
        xKey = true;
        zKey = false;
        setState(() {
          choiceButton = false;
        });
      }
      if (key == LogicalKeyboardKey.arrowUp ||
          key == LogicalKeyboardKey.arrowDown ||
          key == LogicalKeyboardKey.arrowRight ||
          key == LogicalKeyboardKey.arrowLeft) {
        keyArrowControl(key);
        if (zKey) {
          keyStringControl("Z");
        } else if (xKey) {
          keyStringControl("X");
        }
      } else if (zKey && !xKey) {
        keyStringControl("Z");
      } else if (xKey && !zKey) {
        keyStringControl("X");
      }
    }
    if (event is RawKeyUpEvent) {
      if (key == LogicalKeyboardKey.keyZ) {
        zKey = false;
      }
      if (key == LogicalKeyboardKey.keyX) {
        xKey = false;
      }
    }
  }

  void keyArrowControl(final key) {
    cursor(currentRow, currentCol, false, false);
    switch (key) {
      case LogicalKeyboardKey.arrowUp:
        if (currentRow == 0) {
          currentRow = stageSize - 1;
        } else {
          currentRow -= 1;
        }
        break;
      case LogicalKeyboardKey.arrowDown:
        if (currentRow == stageSize - 1) {
          currentRow = 0;
        } else {
          currentRow += 1;
        }
        break;
      case LogicalKeyboardKey.arrowLeft:
        if (currentCol == 0) {
          currentCol = stageSize - 1;
        } else {
          currentCol -= 1;
        }
        break;
      case LogicalKeyboardKey.arrowRight:
        if (currentCol == stageSize - 1) {
          currentCol = 0;
        } else {
          currentCol += 1;
        }
        break;
    }
    cursor(currentRow, currentCol, true, false);
  }

  void keyStringControl(String key) {
    switch (key) {
      case "Z" || "LEFT":
        if (stageCheck[currentRow][currentCol] == 0) {
          if (stageDataList[currentRow][currentCol] != 0) {
            stageCheck[currentRow][currentCol] = 3;
            _checkBoardNum();
            _checkBoardLine();
            finishCheck();
          } else {
            stageCheck[currentRow][currentCol] = 2;
          }
        }
        break;
      case "X" || "RIGHT":
        if (stageCheck[currentRow][currentCol] == 0) {
          stageCheck[currentRow][currentCol] = 1;
        } else if (stageCheck[currentRow][currentCol] == 1) {
          stageCheck[currentRow][currentCol] = 0;
        }
        break;
    }
    cursor(currentRow, currentCol, true, false);
  }

  void _newGetLineNumCol() {
    LineNumClass lineNum;
    List<int> position;
    int sum, count;
    for (int row = 0; row < stageSize; row++) {
      sum = 0;
      count = 0;
      position = [];
      for (int col = 0; col < stageSize; col++) {
        if (col == stageSize - 1) {
          if (stageDataList[row][col] != 0) {
            position.add(col);
            sum++;
          }
          if (sum != 0) {
            lineNum = LineNumClass(row, count, sum, position, false);
            newNumCol.add(lineNum);
            position = [];
          }
        } else if (stageDataList[row][col] == 0 && sum != 0) {
          lineNum = LineNumClass(row, count, sum, position, false);
          newNumCol.add(lineNum);
          position = [];
          count++;
          sum = 0;
        } else if (stageDataList[row][col] != 0) {
          position.add(col);
          sum++;
        }
      }
    }
  }

  void _newGetLineNumRow() {
    LineNumClass lineNum;
    List<int> position;
    int sum, count;
    for (int col = 0; col < stageSize; col++) {
      sum = 0;
      count = 0;
      position = [];
      for (int row = 0; row < stageSize; row++) {
        if (row == stageSize - 1) {
          if (stageDataList[row][col] != 0) {
            position.add(row);
            sum++;
          }
          if (sum != 0) {
            lineNum = LineNumClass(col, count, sum, position, false);
            newNumRow.add(lineNum);
            position = [];
          }
        } else if (stageDataList[row][col] == 0 && sum != 0) {
          lineNum = LineNumClass(col, count, sum, position, false);
          newNumRow.add(lineNum);
          position = [];
          count++;
          sum = 0;
        } else if (stageDataList[row][col] != 0) {
          position.add(row);
          sum++;
        }
      }
    }
  }

  void finishCheck() {
    bool check = true;
    for (int a = 0; a < stageSize; a++) {
      for (int b = 0; b < stageSize; b++) {
        if (stageDataList[a][b] != 0 && stageCheck[a][b] != 3) {
          check = false;
          break;
        }
      }
    }
    if (check) {
      print("stage clear!!");
    }
  }

  void mouseInputControl(String lr, String ud) {
    if (lr == "LEFT") {
      if (ud == "UP") {
        zKey = false;
      } else {
        xKey = false;
        zKey = true;
        keyStringControl(lr);
      }
    } else {
      if (ud == "UP") {
        xKey = false;
      } else {
        zKey = false;
        xKey = true;
        keyStringControl(lr);
      }
    }
  }

  void mouseHoverControl(int hoverRow, int hoverCol) {
    cursor(currentRow, currentCol, false, false);
    cursor(hoverRow, hoverCol, true, false);
    currentRow = hoverRow;
    currentCol = hoverCol;

    if (zKey) {
      keyStringControl("LEFT");
    } else if (xKey) {
      keyStringControl("RIGHT");
    }
  }

  void _checkBoardNum() {
    List<int> positionsListCol = [];
    List<int> positionsListRow = [];

    setState(() {
      int countCol = 0;
      int countRow = 0;
      int checkCol = 0;
      int checkRow = 0;
      for (var lineNum in newNumCol) {
        if (lineNum.line == currentRow &&
            lineNum.position.contains(currentCol)) {
          positionsListCol.addAll(lineNum.position);
          break;
        }
        countCol++;
      }

      for (var lineNum in newNumRow) {
        if (lineNum.line == currentCol &&
            lineNum.position.contains(currentRow)) {
          positionsListRow.addAll(lineNum.position);
          break;
        }
        countRow++;
      }

      for (int i in positionsListCol) {
        if (stageCheck[currentRow][i] == 3) {
          checkCol++;
        }
      }
      if (checkCol == positionsListCol.length && positionsListCol.isNotEmpty) {
        newNumCol[countCol].check = true;
      }

      for (int i in positionsListRow) {
        if (stageCheck[i][currentCol] == 3) {
          checkRow++;
        }
      }

      if (checkRow == positionsListRow.length && positionsListRow.isNotEmpty) {
        newNumRow[countRow].check = true;
      }
    });
  }

  void _checkBoardLine() {
    bool checkCol;
    bool checkRow;

    for (int a = 0; a < stageSize; a++) {
      checkCol = true;
      for (int b = 0; b < stageSize; b++) {
        if (stageDataList[a][b] != 0 && stageCheck[a][b] != 3) {
          checkCol = false;
          break;
        }
      }
      if (checkCol) {
        for (int b = 0; b < stageSize; b++) {
          if (stageCheck[a][b] == 0) {
            stageCheck[a][b] = 1;
            if (a == currentRow && b == currentCol) {
              cursor(a, b, true, true);
            } else {
              cursor(a, b, false, true);
            }
          }
        }
      }
    }

    for (int a = 0; a < stageSize; a++) {
      checkRow = true;
      for (int b = 0; b < stageSize; b++) {
        if (stageDataList[b][a] != 0 && stageCheck[b][a] != 3) {
          checkRow = false;
          break;
        }
      }
      if (checkRow) {
        for (int b = 0; b < stageSize; b++) {
          if (stageCheck[b][a] == 0) {
            stageCheck[b][a] = 1;
            if (b == currentRow && a == currentCol) {
              cursor(b, a, true, true);
            } else {
              cursor(b, a, false, true);
            }
          }
        }
      }
    }
  }

  void _settingNumRow() {
    Color containerColor;
    List<int> positions = [];
    List<bool> check = [];
    newRow = List.filled(stageSize, Container());
    for (int index = 0; index < stageSize; index++) {
      positions = newNumRow
          .where((lineNum) => lineNum.line == index)
          .map((lineNum) => lineNum.number)
          .toList();
      check = newNumRow
          .where((lineNum) => lineNum.line == index)
          .map((lineNum) => lineNum.check)
          .toList();
      if (positions.isEmpty) {
        positions.add(0);
        check.add(true);
      }

      if (index == currentCol) {
        containerColor = Colors.blue;
      } else {
        containerColor = Colors.blueGrey;
      }
      newRow[index] = Container(
          width: (bodySize * 3) / stageSize,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: containerColor,
            border: const Border(
              left: BorderSide(width: 0.5),
              right: BorderSide(width: 0.5),
            ),
          ),
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  children:
                      buildTextSpan(positions, bodySize, "Row", check))));
    }
  }

  void _settingNumCol() {
    Color containerColor;
    List<int> positions = [];
    List<bool> check = [];
    newCol = List.filled(stageSize, Container());
    for (int index = 0; index < stageSize; index++) {
      positions = newNumCol
          .where((lineNum) => lineNum.line == index)
          .map((lineNum) => lineNum.number)
          .toList();
      check = newNumCol
          .where((lineNum) => lineNum.line == index)
          .map((lineNum) => lineNum.check)
          .toList();
      if (positions.isEmpty) {
        positions.add(0);
        check.add(true);
      }
      if (index == currentRow) {
        containerColor = Colors.blue;
      } else {
        containerColor = Colors.blueGrey;
      }

      newCol[index] = Container(
          height: (bodySize * 3) / stageSize,
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: containerColor,
            border: const Border(
              top: BorderSide(width: 0.5),
              bottom: BorderSide(width: 0.5),
            ),
          ),
          child: RichText(
              text: TextSpan(
                  children:
                      buildTextSpan(positions, bodySize, "Col", check))));
    }
  }

  void _initializeMainBoard() {
    Color borderColor;
    BorderSettingClass borders = BorderSettingClass(0.0, 0.0, 0.0, 0.0);
    BackgroundBlockClass blockClass;
    List<List<Widget?>> newBackgroundBoard = List.generate(
        stageSize,
        (index) => List.generate(
              stageSize,
              (index) => null,
            ));
    for (int row = 0; row < stageSize; row++) {
      for (int col = 0; col < stageSize; col++) {
        blockClass =
            getBackgroundColor(stageCheck[row][col], stageDataList[row][col]);
        borders = borderSetting(row, col, stageSize);
        borderColor = Colors.black;
        if (row == 0 && col == 0) {
          newBackgroundBoard[currentRow][currentCol] = BoardBlock(
              backgroundColor: blockClass.backgroundColor,
              blockColor: Colors.blueAccent,
              top: selectBorder,
              bottom: selectBorder,
              left: selectBorder,
              right: selectBorder,
              img: blockClass.backgroundImage);
        } else {
          newBackgroundBoard[row][col] = BoardBlock(
            backgroundColor: blockClass.backgroundColor,
            blockColor: borderColor,
            top: borders.borderTop,
            bottom: borders.borderBottom,
            left: borders.borderLeft,
            right: borders.borderRight,
            img: blockClass.backgroundImage,
          );
        }
      }
    }
    mainBoard = newBackgroundBoard;
  }

  void buttonDisabled(bool disable) {
    setState(() {
      if (disable) {
        choiceButton = false;
      } else {
        choiceButton = true;
      }
      print(choiceButton);
    });
  }

  void buttonClick(String UpDown) {
    if (choiceButton) {
      mouseInputControl("LEFT", UpDown);
    } else {
      mouseInputControl("RIGHT", UpDown);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double windowSize = (getScreeningSize(screenSize));
    double appbarSize = MediaQuery.of(context).padding.top + kToolbarHeight;
    bodySize = (windowSize - appbarSize) / 4 ;
    _settingNumRow();
    _settingNumCol();



    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text(
          "Stage$stageNumber h : $appbarSize w : ${screenSize.width}",
          style: TextStyle(fontSize: bodySize / 7), textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: GestureDetector(
          onSecondaryTap: () {
            setState(() {
              choiceButton = !choiceButton;
            });
          },
          child: MyKeyboardListener(
            onKeyEvent: handleKeyEvent,
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
                            color: Colors.redAccent,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: bodySize / 4,
                                  child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text("Life", style: TextStyle(fontSize: bodySize / 9),)),
                                ),
                                SizedBox(
                                  height: bodySize / 4,
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.favorite),
                                        Icon(Icons.favorite),
                                        Icon(Icons.favorite),
                                        Icon(Icons.favorite),
                                        Icon(Icons.favorite),
                                      ],
                                    ),
                                  )
                                ),
                                Container(
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
                                      MyButton(
                                        buttonSize: bodySize,
                                        icon: Icons.radio_button_off,
                                        iconSize: bodySize / 11,
                                        onPressed: choiceButton
                                            ? null
                                            : () {
                                                buttonDisabled(false);
                                              },
                                      ),
                                      MyButton(
                                        buttonSize: bodySize,
                                        icon: Icons.close,
                                        iconSize: bodySize / 11,
                                        onPressed: choiceButton
                                            ? () {
                                                buttonDisabled(true);
                                              }
                                            : null,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                            //Text(
                            //    "size: $bodySize hegit: ${screenSize.height} wight: ${screenSize.width}"),
                            ),
                        SizedBox(
                          height: bodySize,
                          width: bodySize * 3,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: stageSize,
                            itemBuilder: (context, index) {
                              return newRow[index];
                              //_settingNumRow(bodySize)[index];
                              //Text("$index 입니다.",style: TextStyle(fontSize: (size / 12),color: Colors.yellowAccent),),
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
                              return newCol[index];
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
                                  setState(() {
                                    mouseHoverControl(row, col);
                                  });
                                },
                                child: GestureDetector(
                                    onTapDown: (details) => buttonClick("DOWN"),
                                    onPanStart: (details) =>
                                        buttonClick("DOWN"),
                                    onTapUp: (details) => buttonClick("UP"),
                                    onPanEnd: (details) => buttonClick("UP"),
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
    );
  }
}
