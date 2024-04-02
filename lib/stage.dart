library board_common_data;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nonogram_puzzle/class/stage_board_block.dart';
import 'package:nonogram_puzzle/class/stage_board_block_border_setting.dart';
import 'package:nonogram_puzzle/class/stage_button_change.dart';
import 'package:nonogram_puzzle/class/stage_data_class.dart';
import 'package:nonogram_puzzle/class/stage_number.dart';
import 'class/stage_board_block_color.dart';
import 'function/stage_dialog_function.dart';
import 'class/stage_drawer_menu.dart';
import 'class/stage_key_control.dart';
import 'class/stage_size.dart';
import 'function/stage_board_function.dart';
import 'function/stage_side_function.dart';

/*
1. 주석 작업
2. 변수들 이동 작업 및 변수 이름 변경
3. 함수들 이동 작업 및 함수 이름 변경
4. 힌트기능 추가
 */


class GameBoard extends StatefulWidget {
  final StageData deliveryData;     // 외부에서 가져온 데이터들의 클래스데이터

  const GameBoard({super.key, required this.deliveryData});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {

  List<List<Widget?>> mainBoard = [];   // 화면에 보이게 될 메인 보드 이중 리스트
  List<Widget> topBoard = [];   // 화면에 보이게 될 상단 보드 리스트
  List<Widget> leftBoard = [];   // 화면에 보이게 될 왼쪽 보드 리스트
  List<Widget> lifeList = []; // 생명이 몇개 남았는지 화면에 보여주기 위한 리스트

// 0 : 기본상태(회색) 1 : 사용자가 x를 누른 상태(회색X 이미지 생성) 2 : 사용자가 정답을 틀린 상태(빨간색 X이미지 생성) 3 : 사용자가 정답을 맞춘 상태
// 사용자가 해당 블록에 행동한 기록을 가지고 있는 이중 리스트
  List<List<int>> stageCheck = [];
  List<List<int>> stageDataList = [];   // 외부에서 가져온 숫자로 구성된 데이터로 색 정보를 가지고 있는 이중 리스트
  List<LineNumClass> topBoardData = [];    //보드 상단에 위치한 보드의 숫자 데이터를 보여주는 리스트
  List<LineNumClass> leftBoardData = [];    //보드 좌측에 위치한 보드의 숫자 데이터를 보여주는 리스트

  int stageSize = 0;   //보드의 크기를 정하기 위해 외부에서 가져온 변수
  int stageNumber = 0; //해당 스테이지의 번호를 외부에서 가져온 변수
  double bodySize = 0.0; //해당 화면의 Scaffold의 body의 크기를 가지고 있는 변수

  int life = 5;   // 해당 보드 게임의 생명 개수

  int currentRow = 0; //현재 커서의 row 위치 변수
  int currentCol = 0; //현재 커서의 col 위치 변수

  double selectBorder = 2.0;  // 커서의 외곽선 두께 변수

  bool zKey = false;  // z키가 눌려있는지 확인하는 변수
  bool xKey = false;  // x키가 눌려있는지 확인하는 변수
  bool choiceButton = true; // 마우스로 조작할 때 좌클릭으로 z,x버튼을 사용할수 있도록 우클릭으로 조작하는 변수

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
    topBoardData = settingTopBoard(stageSize,stageDataList);
    leftBoardData = settingLeftBoard(stageSize,stageDataList);
    mainBoard = initializeMainBoard(stageSize,stageCheck,stageDataList,currentRow,currentCol,selectBorder);
    checkMainBoard();
    initializeLifeBoard();
  }

  //데이터를 외부에 저장하는 함수
  void _saveData(){

  }

  //저장된 데이터를 불러오는 함수
  void _loadData(){

  }

  // 생명이 몇개 남아있는지 표시해주는 함수
  void initializeLifeBoard(){
    List<Widget> newLife = [];
    for(int i = 0; i < life; i++){
      newLife.add(
        const Icon(Icons.favorite, color: Colors.blue,)
      );
    }
    lifeList = newLife;
  }

  // 메인 보드의 블록들을 설정하는 함수
  void blockPieceSetting(int row, int col, bool check, bool img) {
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

  // 입력된 키의 이벤트를 처리하는 함수
  void keyEvent(RawKeyEvent? event) {
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

  // 입력된 키의 이벤트 중 방향키 이동을 처리하는 함수
  void keyArrowControl(final key) {
    blockPieceSetting(currentRow, currentCol, false, false);
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
    blockPieceSetting(currentRow, currentCol, true, false);
  }

  // 입려된 키의 이벤트 중 z키,x키,마우스 좌클릭을 처리하는 함수
  void keyStringControl(String key) {
    switch (key) {
      case "Z" || "LEFT":
        if (stageCheck[currentRow][currentCol] == 0) {
          if (stageDataList[currentRow][currentCol] != 0) {
            stageCheck[currentRow][currentCol] = 3;
            checkNumberBoard();
            checkMainBoard();
            gameClearEvent();
          } else {
            stageCheck[currentRow][currentCol] = 2;
            lifeList.removeLast();
            if(lifeList.isEmpty){
              gameOverEvent();
            }
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
    blockPieceSetting(currentRow, currentCol, true, false);
  }

  // 보드의 가로줄의 숫자를 숫자보드에 표시하기 위해 처리하는 함수
  // void settingLeftBoard() {
  //   LineNumClass lineNum;
  //   List<int> position;
  //   int sum, count;
  //   for (int row = 0; row < stageSize; row++) {
  //     sum = 0;
  //     count = 0;
  //     position = [];
  //     for (int col = 0; col < stageSize; col++) {
  //       if (col == stageSize - 1) {
  //         if (stageDataList[row][col] != 0) {
  //           position.add(col);
  //           sum++;
  //         }
  //         if (sum != 0) {
  //           lineNum = LineNumClass(row, count, sum, position, false);
  //           leftBoardData.add(lineNum);
  //           position = [];
  //         }
  //       } else if (stageDataList[row][col] == 0 && sum != 0) {
  //         lineNum = LineNumClass(row, count, sum, position, false);
  //         leftBoardData.add(lineNum);
  //         position = [];
  //         count++;
  //         sum = 0;
  //       } else if (stageDataList[row][col] != 0) {
  //         position.add(col);
  //         sum++;
  //       }
  //     }
  //   }
  // }

  // // 보드의 세로줄의 숫자를 숫자보드에 표시하기 위해 처리하는 함수
  // void settingTopBoard() {
  //   LineNumClass lineNum;
  //   List<int> position;
  //   int sum, count;
  //   for (int col = 0; col < stageSize; col++) {
  //     sum = 0;
  //     count = 0;
  //     position = [];
  //     for (int row = 0; row < stageSize; row++) {
  //       if (row == stageSize - 1) {
  //         if (stageDataList[row][col] != 0) {
  //           position.add(row);
  //           sum++;
  //         }
  //         if (sum != 0) {
  //           lineNum = LineNumClass(col, count, sum, position, false);
  //           topBoardData.add(lineNum);
  //           position = [];
  //         }
  //       } else if (stageDataList[row][col] == 0 && sum != 0) {
  //         lineNum = LineNumClass(col, count, sum, position, false);
  //         topBoardData.add(lineNum);
  //         position = [];
  //         count++;
  //         sum = 0;
  //       } else if (stageDataList[row][col] != 0) {
  //         position.add(row);
  //         sum++;
  //       }
  //     }
  //   }
  // }

  // 게임 클리어 조건을 검사해서 처리하는 함수
  void gameClearEvent() {
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
      gameClearDialog(context);
    }
  }

  // 라이프가 다 깎였을 시 다이얼로그를 실행시켜주는 함수
  void gameOverEvent(){
    gameOverDialog(context, widget.deliveryData);
  }

  // 마우스 왼쪽 오른쪽 클릭 이벤트를 처리하는 함수
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

  // 마우스를 보드 위에 올렸을시에 이벤트를 처리하는 함수
  void mouseHoverControl(int hoverRow, int hoverCol) {
    blockPieceSetting(currentRow, currentCol, false, false);
    blockPieceSetting(hoverRow, hoverCol, true, false);
    currentRow = hoverRow;
    currentCol = hoverCol;

    if (zKey) {
      keyStringControl("LEFT");
    } else if (xKey) {
      keyStringControl("RIGHT");
    }
  }

  // 보드를 체크하여 숫자보드의 숫자의 처리유무를 처리하는 함수
  void checkNumberBoard() {
    List<int> positionsListCol = [];
    List<int> positionsListRow = [];

    setState(() {
      int countCol = 0;
      int countRow = 0;
      int checkCol = 0;
      int checkRow = 0;
      for (var lineNum in leftBoardData) {
        if (lineNum.line == currentRow &&
            lineNum.position.contains(currentCol)) {
          positionsListCol.addAll(lineNum.position);
          break;
        }
        countCol++;
      }

      for (var lineNum in topBoardData) {
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
        leftBoardData[countCol].check = true;
      }

      for (int i in positionsListRow) {
        if (stageCheck[i][currentCol] == 3) {
          checkRow++;
        }
      }

      if (checkRow == positionsListRow.length && positionsListRow.isNotEmpty) {
        topBoardData[countRow].check = true;
      }
    });
  }

  // 보드의 가로 혹은 세로줄에서 더이상 맞출 칸이 없을시 나머지칸을 회색 X자로 채워지게 처리하는 함수
  void checkMainBoard() {
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
              blockPieceSetting(a, b, true, true);
            } else {
              blockPieceSetting(a, b, false, true);
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
              blockPieceSetting(b, a, true, true);
            } else {
              blockPieceSetting(b, a, false, true);
            }
          }
        }
      }
    }
  }

  // // 위쪽 숫자보드의 숫자를 배치하여 처리하는 함수
  // void initializeTopBoard() {
  //   Color containerColor;
  //   List<int> positions = [];
  //   List<bool> check = [];
  //   topBoard = List.filled(stageSize, Container());
  //   for (int index = 0; index < stageSize; index++) {
  //     positions = topBoardData
  //         .where((lineNum) => lineNum.line == index)
  //         .map((lineNum) => lineNum.number)
  //         .toList();
  //     check = topBoardData
  //         .where((lineNum) => lineNum.line == index)
  //         .map((lineNum) => lineNum.check)
  //         .toList();
  //     if (positions.isEmpty) {
  //       positions.add(0);
  //       check.add(true);
  //     }
  //
  //     if (index == currentCol) {
  //       containerColor = Colors.blue;
  //     } else {
  //       containerColor = Colors.blueGrey;
  //     }
  //     topBoard[index] = Container(
  //         width: (bodySize * 3) / stageSize,
  //         alignment: Alignment.bottomCenter,
  //         decoration: BoxDecoration(
  //           color: containerColor,
  //           border: const Border(
  //             left: BorderSide(width: 0.5),
  //             right: BorderSide(width: 0.5),
  //           ),
  //         ),
  //         child: RichText(
  //             textAlign: TextAlign.center,
  //             text: TextSpan(
  //                 children:
  //                     buildTextSpan(positions, bodySize, "Row", check))));
  //   }
  // }
  //
  // // 왼쪽 숫자보드의 숫자를 배치하여 처리하는 함수
  // void initializeLeftBoard() {
  //   Color containerColor;
  //   List<int> positions = [];
  //   List<bool> check = [];
  //   leftBoard = List.filled(stageSize, Container());
  //   for (int index = 0; index < stageSize; index++) {
  //     positions = leftBoardData
  //         .where((lineNum) => lineNum.line == index)
  //         .map((lineNum) => lineNum.number)
  //         .toList();
  //     check = leftBoardData
  //         .where((lineNum) => lineNum.line == index)
  //         .map((lineNum) => lineNum.check)
  //         .toList();
  //     if (positions.isEmpty) {
  //       positions.add(0);
  //       check.add(true);
  //     }
  //     if (index == currentRow) {
  //       containerColor = Colors.blue;
  //     } else {
  //       containerColor = Colors.blueGrey;
  //     }
  //
  //     leftBoard[index] = Container(
  //         height: (bodySize * 3) / stageSize,
  //         alignment: Alignment.centerRight,
  //         decoration: BoxDecoration(
  //           color: containerColor,
  //           border: const Border(
  //             top: BorderSide(width: 0.5),
  //             bottom: BorderSide(width: 0.5),
  //           ),
  //         ),
  //         child: RichText(
  //             text: TextSpan(
  //                 children:
  //                     buildTextSpan(positions, bodySize, "Col", check))));
  //   }
  // }

  // //메인 보드를 초기 설정하는 함수
  // void initializeMainBoard() {
  //   Color borderColor;
  //   BorderSettingClass borders = BorderSettingClass(0.0, 0.0, 0.0, 0.0);
  //   BackgroundBlockClass blockClass;
  //   List<List<Widget?>> newMainBoard = List.generate(
  //       stageSize,
  //       (index) => List.generate(
  //             stageSize,
  //             (index) => null,
  //           ));
  //   for (int row = 0; row < stageSize; row++) {
  //     for (int col = 0; col < stageSize; col++) {
  //       blockClass =
  //           getBackgroundColor(stageCheck[row][col], stageDataList[row][col]);
  //       borders = borderSetting(row, col, stageSize);
  //       borderColor = Colors.black;
  //       if (row == 0 && col == 0) {
  //         newMainBoard[currentRow][currentCol] = BoardBlock(
  //             backgroundColor: blockClass.backgroundColor,
  //             blockColor: Colors.blueAccent,
  //             top: selectBorder,
  //             bottom: selectBorder,
  //             left: selectBorder,
  //             right: selectBorder,
  //             img: blockClass.backgroundImage);
  //       } else {
  //         newMainBoard[row][col] = BoardBlock(
  //           backgroundColor: blockClass.backgroundColor,
  //           blockColor: borderColor,
  //           top: borders.borderTop,
  //           bottom: borders.borderBottom,
  //           left: borders.borderLeft,
  //           right: borders.borderRight,
  //           img: blockClass.backgroundImage,
  //         );
  //       }
  //     }
  //   }
  //   mainBoard = newMainBoard;
  // }

  // 마우스 오른쪽 클릭으로 z,x버튼을 선택하여 사용할 수 있게 하는 함수
  void mouseButtonDisabled(bool disable) {
    setState(() {
      if (disable) {
        choiceButton = false;
      } else {
        choiceButton = true;
      }
    });
  }

  // 마우스 왼쪽 버튼을 클릭했을때 처리하는 함수
  void mouseButtonClick(String upDown) {
    if (choiceButton) {
      mouseInputControl("LEFT", upDown);
    } else {
      mouseInputControl("RIGHT", upDown);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double windowSize = (getScreeningSize(screenSize));
    double appbarSize = MediaQuery.of(context).padding.top + kToolbarHeight;
    bodySize = (windowSize - appbarSize) / 4 ;
    topBoard = initializeTopBoard(stageSize,currentCol,bodySize,topBoardData);
    leftBoard = initializeLeftBoard(stageSize,currentRow,bodySize,leftBoardData);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
        title: Text(
          "Stage$stageNumber",
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
            onKeyEvent: keyEvent,
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
                                      children:lifeList,
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
                                                mouseButtonDisabled(false);
                                              },
                                      ),
                                      MyButton(
                                        buttonSize: bodySize,
                                        icon: Icons.close,
                                        iconSize: bodySize / 11,
                                        onPressed: choiceButton
                                            ? () {
                                                mouseButtonDisabled(true);
                                              }
                                            : null,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                            ),
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
                                  setState(() {
                                    mouseHoverControl(row, col);
                                  });
                                },
                                child: GestureDetector(
                                    onTapDown: (details) => mouseButtonClick("DOWN"),
                                    onPanStart: (details) =>
                                        mouseButtonClick("DOWN"),
                                    onTapUp: (details) => mouseButtonClick("UP"),
                                    onPanEnd: (details) => mouseButtonClick("UP"),
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
      endDrawer: stageSettingMenu(context),
    );
  }
}
