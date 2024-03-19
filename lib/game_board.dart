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

  void touchControl(int touchRow, int touchCol) {
    setState(() {
      BackgroundBlockClass blockClass = getBackgroundColor(
          stageCheck[currentRow][currentCol],
          stageDataList[currentRow][currentCol]);
      double selectBorder = 2.0;
      BorderSettingClass borders =
          borderSetting(currentRow, currentCol, stageSize);
      mainBoard[currentRow][currentCol] = BoardBlock(
          backgroundColor: blockClass.backgroundColor,
          blockColor: Colors.black,
          top: borders.borderTop,
          bottom: borders.borderBottom,
          left: borders.borderLeft,
          right: borders.borderRight,
          img: blockClass.backgroundImage);
      mainBoard[touchRow][touchCol] = BoardBlock(
          backgroundColor: blockClass.backgroundColor,
          blockColor: Colors.blueAccent,
          top: selectBorder,
          bottom: selectBorder,
          left: selectBorder,
          right: selectBorder,
          img: blockClass.backgroundImage);
      currentRow = touchRow;
      currentCol = touchCol;
      print("ROW $touchRow COL $touchCol");
    });
  }

  void keyboardControl(String arrow) {
    setState(() {
      BackgroundBlockClass blockClass = getBackgroundColor(
          stageCheck[currentRow][currentCol],
          stageDataList[currentRow][currentCol]);
      BorderSettingClass borders =
          borderSetting(currentRow, currentCol, stageSize);

      mainBoard[currentRow][currentCol] = BoardBlock(
          backgroundColor: blockClass.backgroundColor,
          blockColor: Colors.black,
          top: borders.borderTop,
          bottom: borders.borderBottom,
          left: borders.borderLeft,
          right: borders.borderRight,
          img: blockClass.backgroundImage);

      switch (arrow) {
        case "UP":
          if (currentRow == 0) {
            currentRow = stageSize - 1;
          } else {
            currentRow -= 1;
          }
          break;
        case "DOWN":
          if (currentRow == stageSize - 1) {
            currentRow = 0;
          } else {
            currentRow += 1;
          }
          break;
        case "LEFT":
          if (currentCol == 0) {
            currentCol = stageSize - 1;
          } else {
            currentCol -= 1;
          }
          break;
        case "RIGHT":
          if (currentCol == stageSize - 1) {
            currentCol = 0;
          } else {
            currentCol += 1;
          }
          break;
      }
      print("$currentRow, $currentCol");
      blockClass = getBackgroundColor(stageCheck[currentRow][currentCol],
          stageDataList[currentRow][currentCol]);
      mainBoard[currentRow][currentCol] = BoardBlock(
          backgroundColor: blockClass.backgroundColor,
          blockColor: Colors.blueAccent,
          top: selectBorder,
          bottom: selectBorder,
          left: selectBorder,
          right: selectBorder,
          img: blockClass.backgroundImage);
    });
  }

  void keyboardControlZX(String k) {
    setState(() {
      switch (k) {
        case "Z":

          if (stageCheck[currentRow][currentCol] == 0) {
            if (stageDataList[currentRow][currentCol] != 0) {
              stageCheck[currentRow][currentCol] = 3;
              _checkBoardNum();
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
      BackgroundBlockClass blockClass = getBackgroundColor(
          stageCheck[currentRow][currentCol],
          stageDataList[currentRow][currentCol]);
      mainBoard[currentRow][currentCol] = BoardBlock(
        backgroundColor: blockClass.backgroundColor,
        blockColor: Colors.blueAccent,
        top: selectBorder,
        bottom: selectBorder,
        left: selectBorder,
        right: selectBorder,
        img: blockClass.backgroundImage,
      );
    });
  }

  void _checkBoardNum(){

    // List<List<int>> positionsListCol = newNumCol
    //     .where((lineNum) => lineNum.line == currentRow && lineNum.position.contains(currentCol))
    //     .map((lineNum) => lineNum.position)
    //     .toList();
    //
    // List<List<int>> positionsListRow = newNumRow
    //     .where((lineNum) => lineNum.line == currentCol && lineNum.position.contains(currentRow))
    //     .map((lineNum) => lineNum.position)
    //     .toList();

    List<int> positionsListCol = [];
    List<int> positionsListRow = [];

    setState(() {
      int countCol = 0;
      int countRow = 0;
      int checkCol = 0;
      int checkRow = 0;
      for (var lineNum in newNumCol) {
        if (lineNum.line == currentRow && lineNum.position.contains(currentCol)) {
          positionsListCol.addAll(lineNum.position);
          break;
        }
        countCol++;
      }

      for (var lineNum in newNumRow) {
        if (lineNum.line == currentCol && lineNum.position.contains(currentRow)) {
          positionsListRow.addAll(lineNum.position);
          break;
        }
        countRow++;
      }

      for(int i in positionsListCol){
        if(stageCheck[currentRow][i] == 3){
          checkCol++;
        }
      }
      if(checkCol == positionsListCol.length && positionsListCol.isNotEmpty){
        newNumCol[countCol].check = true;
      }

      for(int i in positionsListRow){
        if(stageCheck[i][currentCol] == 3){
          checkRow++;
        }
      }

      if(checkRow == positionsListRow.length && positionsListRow.isNotEmpty){
        newNumRow[countRow].check = true;
      }
      //print(checkCol);
      print("$positionsListCol $positionsListRow");
    });
  }

  void checkBoardLine(){

  }

  List<Widget> _settingNumRow(double wSize){
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
                  children: buildTextSpan(
                      positions, wSize, "Row", check)))
        //Text("$index 입니다.",style: TextStyle(fontSize: (size / 12),color: Colors.yellowAccent),),
      );
    }
    return newRow;
  }

  List<Widget> _settingNumCol(double wSize){
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
                  children: buildTextSpan(
                      positions, wSize, "Col",check)))
        //Text("$index 입니다.",style: TextStyle(fontSize: (size / 12),color: Colors.yellowAccent),),
      );
    }
    return newCol;
  }

  void _initializeMainBoard() {
    Color borderColor;
    BorderSettingClass borders = BorderSettingClass(0.0, 0.0, 0.0, 0.0);
    List<List<Widget?>> newBackgroundBoard = List.generate(
        stageSize,
        (index) => List.generate(
              stageSize,
              (index) => null,
            ));
    for (int row = 0; row < stageSize; row++) {
      for (int col = 0; col < stageSize; col++) {
        BackgroundBlockClass blockClass =
            getBackgroundColor(stageCheck[row][col], stageDataList[row][col]);
        borders = borderSetting(row, col, stageSize);
        borderColor = Colors.black;

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
    mainBoard = newBackgroundBoard;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double widgetSize = (getScreeningSize(screenSize)) / 4;

    return Scaffold(
      body: Center(
        child: Shortcuts(
          shortcuts: const <ShortcutActivator, Intent>{
            SingleActivator(LogicalKeyboardKey.arrowUp): IncrementIntentUP(),
            SingleActivator(LogicalKeyboardKey.arrowDown):
                IncrementIntentDOWN(),
            SingleActivator(LogicalKeyboardKey.arrowLeft):
                IncrementIntentLEFT(),
            SingleActivator(LogicalKeyboardKey.arrowRight):
                IncrementIntentRIGHT(),
            SingleActivator(LogicalKeyboardKey.keyZ): IncrementIntentZ(),
            SingleActivator(LogicalKeyboardKey.keyX): IncrementIntentX(),
          },
          child: Actions(
            actions: {
              IncrementIntentUP: CallbackAction<IncrementIntentUP>(
                  onInvoke: (intent) => keyboardControl("UP")),
              IncrementIntentDOWN: CallbackAction<IncrementIntentDOWN>(
                  onInvoke: (intent) => keyboardControl("DOWN")),
              IncrementIntentLEFT: CallbackAction<IncrementIntentLEFT>(
                  onInvoke: (intent) => keyboardControl("LEFT")),
              IncrementIntentRIGHT: CallbackAction<IncrementIntentRIGHT>(
                  onInvoke: (intent) => keyboardControl("RIGHT")),
              IncrementIntentZ: CallbackAction<IncrementIntentZ>(
                  onInvoke: (intent) => keyboardControlZX("Z")),
              IncrementIntentX: CallbackAction<IncrementIntentX>(
                  onInvoke: (intent) => keyboardControlZX("X")),
            },
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
                                    onSecondaryTap:  () => touchControl(row, col),
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
      ),
    );
  }
}
