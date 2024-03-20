import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nonogram_puzzle/components/block.dart';
import 'package:nonogram_puzzle/components/border_setting.dart';
import 'package:nonogram_puzzle/components/stage_data_class.dart';
import 'package:nonogram_puzzle/components/stage_number.dart';
import 'components/block_color.dart';
import 'components/key_control.dart';
import 'components/stage_size.dart';

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

  List<LineNumClass> newNumRow = [];
  List<LineNumClass> newNumCol = [];

  late List<Widget> newRow;
  late List<Widget> newCol;

  int currentRow = 0;
  int currentCol = 0;

  int selectedRow = 0;
  int selectedCol = 0;

  double selectBorder = 2.0;

  bool zKey = false;
  bool xKey = false;

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

  void handleKeyEvent(RawKeyEvent event) {
    // 키 이벤트 처리
    final key = event.data.logicalKey;
    if (event is RawKeyDownEvent) {
      if (key == LogicalKeyboardKey.keyZ) {
        zKey = true;
        xKey = false;
      }
      if (key == LogicalKeyboardKey.keyX) {
        xKey = true;
        zKey = false;
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

      if (key == LogicalKeyboardKey.keyC) {
        print("cpzm");
        _checkBoardLine();
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
    print("$currentRow, $currentCol");
    cursor(currentRow, currentCol, true, false);
  }

  void keyStringControl(String key) {
    switch (key) {
      case "Z":
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
      case "X":
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

  void finishCheck(){
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

  void touchControl(int touchRow, int touchCol) {
    cursor(currentRow, currentCol, false, false);
    cursor(touchRow, touchCol, true, false);
    currentRow = touchRow;
    currentCol = touchCol;
    print("ROW $touchRow COL $touchCol");
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
      //print(checkCol);
      print("$positionsListCol $positionsListRow");
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

  List<Widget> _settingNumRow(double wSize) {
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
      newRow[index] = Container(
          width: (wSize * 3) / stageSize,
          alignment: Alignment.bottomCenter,
          decoration: const BoxDecoration(
            color: Colors.blueGrey,
            border: Border(
              left: BorderSide(width: 0.5),
              right: BorderSide(width: 0.5),
            ),
          ),
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  children: buildTextSpan(positions, wSize, "Row", check)))
          //Text("$index 입니다.",style: TextStyle(fontSize: (size / 12),color: Colors.yellowAccent),),
          );
    }
    return newRow;
  }

  List<Widget> _settingNumCol(double wSize) {
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

      newCol[index] = Container(
          height: (wSize * 3) / stageSize,
          alignment: Alignment.centerRight,
          decoration: const BoxDecoration(
            color: Colors.blueGrey,
            border: Border(
              top: BorderSide(width: 0.5),
              bottom: BorderSide(width: 0.5),
            ),
          ),
          child: RichText(
              text: TextSpan(
                  children: buildTextSpan(positions, wSize, "Col", check)))
          //Text("$index 입니다.",style: TextStyle(fontSize: (size / 12),color: Colors.yellowAccent),),
          );
    }
    return newCol;
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

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double widgetSize = (getScreeningSize(screenSize)) / 4;

    return Scaffold(
      body: Center(
        child: MyKeyboardListener(
          onKeyEvent: handleKeyEvent,
          child: Focus(
            autofocus: true,
            child: SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: widgetSize,
                          width: widgetSize,
                          color: Colors.redAccent,
                          child: Text(
                              "size: $widgetSize hegit: ${screenSize.height} wight: ${screenSize.width}"),
                        ),
                        SingleChildScrollView(
                          child: SizedBox(
                            height: widgetSize,
                            width: widgetSize * 3,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: stageSize,
                              itemBuilder: (context, index) {
                                return _settingNumRow(widgetSize)[index];
                                //Text("$index 입니다.",style: TextStyle(fontSize: (size / 12),color: Colors.yellowAccent),),
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SingleChildScrollView(
                          child: SizedBox(
                            height: widgetSize * 3,
                            width: widgetSize,
                            child: ListView.builder(
                              itemCount: stageSize,
                              itemBuilder: (context, index) {
                                return _settingNumCol(widgetSize)[index];
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: widgetSize * 3,
                          width: widgetSize * 3,
                          child: GridView.builder(
                            itemCount: stageSize * stageSize,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: stageSize),
                            itemBuilder: (context, index) {
                              int row = index ~/ stageSize;
                              int col = index % stageSize;

                              return GestureDetector(
                                  onTap: () => touchControl(row, col),
                                  onSecondaryTap: () => touchControl(row, col),
                                  child: mainBoard[row][col]);
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
