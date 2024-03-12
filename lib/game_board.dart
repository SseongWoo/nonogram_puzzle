import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:nonogram_puzzle/components/block.dart';
import 'package:nonogram_puzzle/components/border_setting.dart';
import 'package:nonogram_puzzle/components/stage_data_class.dart';
import 'components/key_control.dart';

class GameBoard extends StatefulWidget {
  final StageData deliveryData;

  const GameBoard({super.key, required this.deliveryData});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late List<List<Widget?>> colorBoard;
  late List<List<int>> stageDataList;
  late List<List<int>> stageCheck;
  late List<List<int>> listCol;
  late List<List<int>> listRow;
  late int stageHW;
  late int stageNumber;
  late Size screenSize;

  int currentRow = 0;
  int currentCol = 0;

  int selectedRow = 0;
  int selectedCol = 0;

  bool pushKeyZ = false;

  @override
  void initState() {
    super.initState();
    stageNumber = widget.deliveryData.number;
    stageDataList = widget.deliveryData.stage;
    stageHW = widget.deliveryData.hw;
    stageCheck = List.generate(
      stageHW,
      (index) => List<int>.filled(stageHW, 0),
    );
    _initializeBackgroundBoard();
  }

  void touchControl(int touchRow, int touchCol) {
    setState(() {
      double selectBorder = 2.0;
      BorderSettingClass borders =
          borderSetting(currentRow, currentCol, stageHW);
      colorBoard[currentRow][currentCol] = BoardBlock(
          backgroundColor: stageCheck[currentRow][currentCol],
          blockColor: Colors.black,
          top: borders.borderTop,
          bottom: borders.borderBottom,
          left: borders.borderLeft,
          right: borders.borderRight);
      colorBoard[touchRow][touchCol] = BoardBlock(
          backgroundColor: stageCheck[touchRow][touchCol],
          blockColor: Colors.blueAccent,
          top: selectBorder,
          bottom: selectBorder,
          left: selectBorder,
          right: selectBorder);
      currentRow = touchRow;
      currentCol = touchCol;
      print("ROW $touchRow COL $touchCol");
    });
  }

  void keyboardControl(String arrow) {
    setState(() {
      BorderSettingClass borders =
          borderSetting(currentRow, currentCol, stageHW);
      double selectBorder = 2.0;

      colorBoard[currentRow][currentCol] = BoardBlock(
          backgroundColor: stageCheck[currentRow][currentCol],
          blockColor: Colors.black,
          top: borders.borderTop,
          bottom: borders.borderBottom,
          left: borders.borderLeft,
          right: borders.borderRight);

      switch (arrow) {
        case "UP":
          if (currentRow == 0) {
            currentRow = stageHW - 1;
          } else {
            currentRow -= 1;
          }
          break;
        case "DOWN":
          if (currentRow == stageHW - 1) {
            currentRow = 0;
          } else {
            currentRow += 1;
          }
          break;
        case "LEFT":
          if (currentCol == 0) {
            currentCol = stageHW - 1;
          } else {
            currentCol -= 1;
          }
          break;
        case "RIGHT":
          if (currentCol == stageHW - 1) {
            currentCol = 0;
          } else {
            currentCol += 1;
          }

          break;
      }

      colorBoard[currentRow][currentCol] = BoardBlock(
          backgroundColor: stageCheck[currentRow][currentCol],
          blockColor: Colors.blueAccent,
          top: selectBorder,
          bottom: selectBorder,
          left: selectBorder,
          right: selectBorder);
    });
  }

  void keyboardControlZX(String k) {
    setState(() {
      switch (k) {
        case "Z":
          break;

        case "X":
          break;
      }
    });
  }

  void _initializeBackgroundBoard() {
    List<List<Widget?>> newBackgroundBoard = List.generate(
        stageHW,
        (index) => List.generate(
              stageHW,
              (index) => null,
            ));

    Color cr;
    for (int row = 0; row < stageHW; row++) {
      for (int col = 0; col < stageHW; col++) {
        // switch (stageDataList[row][col]) {
        //   case -1:
        //     cr = Colors.black;
        //     break;
        //   case 1:
        //     cr = Colors.red;
        //     break;
        //   case 2:
        //     cr = Colors.orange;
        //     break;
        //   case 3:
        //     cr = Colors.yellow;
        //     break;
        //   case 4:
        //     cr = Colors.green;
        //     break;
        //   default:
        //     cr = Colors.transparent; // 기본값
        //     break;
        // }
        cr = Colors.grey;
        BorderSettingClass borders = borderSetting(row, col, stageHW);

        newBackgroundBoard[row][col] = Container(
          decoration: BoxDecoration(
            color: cr, // 배경색
            border: Border(
              top: BorderSide(
                color: Colors.black, // 외곽선 색상
                width: borders.borderTop, // 상단 외곽선 두께
              ),
              bottom: BorderSide(
                color: Colors.black, // 외곽선 색상
                width: borders.borderBottom, // 하단 외곽선 두께
              ),
              left: BorderSide(
                color: Colors.black, // 외곽선 색상
                width: borders.borderLeft, // 좌측 외곽선 두께
              ),
              right: BorderSide(
                color: Colors.black, // 외곽선 색상
                width: borders.borderRight, // 우측 외곽선 두께
              ),
            ),
          ),
          child: Image.asset("assets/img/empty_block.png"),
        );

        // cr = Colors.grey;
        // newBackgroundBoard[row][col] = Container(
        //   decoration: BoxDecoration(
        //     color: cr,
        //       border: Border.all(
        //     color: Colors.black,
        //     width: borderWidth,
        //   )),
        //   child: Image.asset("assets/img/empty_block.png"),
        // );
      }
    }
    colorBoard = newBackgroundBoard;
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

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
              child: SizedBox(
                width: screenSize.width > screenSize.height
                    ? screenSize.width / 2 > 400
                        ? screenSize.width / 2
                        : 400
                    : screenSize.height / 2 > 400
                        ? screenSize.height / 2
                        : 400,
                height: screenSize.height > screenSize.width
                    ? screenSize.height / 2 > 400
                        ? screenSize.height / 2
                        : 400
                    : screenSize.width / 2 > 400
                        ? screenSize.width / 2
                        : 400,
                child: Column(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(color: Colors.redAccent,),
                          ),
                          Flexible(
                              flex: 2,
                              child: Container(color: Colors.blueAccent,))
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                              color: Colors.greenAccent,
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: SizedBox(
                              child: GridView.builder(
                                itemCount: stageHW * stageHW,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: stageHW),
                                itemBuilder: (context, index) {
                                  int row = index ~/ stageHW;
                                  int col = index % stageHW;

                                  return GestureDetector(
                                      onTap: () => touchControl(row, col),
                                      child: colorBoard[row][col]);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
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
