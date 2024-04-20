import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nonogram_puzzle/stage/board/piece_change.dart';
import 'board/check_board.dart';
import 'other_function.dart';
import 'stage_event.dart';
import 'global_variable.dart';

//키보드 이벤트 클래스
class MyKeyboardListener extends StatefulWidget {
  final Widget? child;
  final Function(RawKeyEvent) onKeyEvent; // 콜백

  const MyKeyboardListener({super.key, this.child, required this.onKeyEvent});

  @override
  _KeyboardListenerState createState() => _KeyboardListenerState();
}

class _KeyboardListenerState extends State<MyKeyboardListener> {
  @override
  void initState() {
    super.initState();
    RawKeyboard.instance.addListener(_handleKeyEvent);
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleKeyEvent);
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    widget.onKeyEvent(event); // 콜백 호출
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? Container();
  }
}

// 입력된 키의 이벤트를 처리하는 함수
void keyEvent(RawKeyEvent? event) {
  final key = event?.data.logicalKey;
  if (event is RawKeyDownEvent) {
    if (key == LogicalKeyboardKey.keyZ) {
      zKey = true;
      xKey = false;
      choiceButton = true;
    }
    if (key == LogicalKeyboardKey.keyX) {
      xKey = true;
      zKey = false;
      choiceButton = false;
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
  boardPieceChange(currentRow, currentCol, false, false);
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
  boardPieceChange(currentRow, currentCol, true, false);
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
          if(gameClearEvent()){
            playSound(2);
          }else{
            playSound(0);
          }
        } else {
          stageCheck[currentRow][currentCol] = 2;
          lifeList.removeLast();
          life--;
          if (lifeList.isEmpty) {
            playSound(4);
            gameOverEvent();
          }else{
            playSound(3);
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
      playSound(1);
      break;
  }
  boardPieceChange(currentRow, currentCol, true, false);
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
  boardPieceChange(currentRow, currentCol, false, false);
  boardPieceChange(hoverRow, hoverCol, true, false);
  currentRow = hoverRow;
  currentCol = hoverCol;

  if (zKey) {
    keyStringControl("LEFT");
  } else if (xKey) {
    keyStringControl("RIGHT");
  }
}

// 마우스 오른쪽 클릭으로 z,x버튼을 선택하여 사용할 수 있게 하는 함수
void mouseButtonDisabled(bool disable) {
  if (disable) {
    choiceButton = false;
  } else {
    choiceButton = true;
  }
}

// 마우스 왼쪽 버튼을 클릭했을때 처리하는 함수
void mouseButtonClick(String upDown) {
  if (choiceButton) {
    mouseInputControl("LEFT", upDown);
  } else {
    mouseInputControl("RIGHT", upDown);
  }
}
