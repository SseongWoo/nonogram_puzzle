import 'piece_change.dart';
import '../global_variable.dart';

// 보드를 체크하여 숫자보드의 숫자의 처리유무를 처리하는 함수
void checkNumberBoard() {
  List<int> positionsListCol = [];
  List<int> positionsListRow = [];

  int countCol = 0;
  int countRow = 0;
  int checkCol = 0;
  int checkRow = 0;
  for (var lineNum in leftBoardData) {
    if (lineNum.line == currentRow && lineNum.position.contains(currentCol)) {
      positionsListCol.addAll(lineNum.position);
      break;
    }
    countCol++;
  }

  for (var lineNum in topBoardData) {
    if (lineNum.line == currentCol && lineNum.position.contains(currentRow)) {
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
            boardPieceChange(a, b, true, true);
          } else {
            boardPieceChange(a, b, false, true);
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
            boardPieceChange(b, a, true, true);
          } else {
            boardPieceChange(b, a, false, true);
          }
        }
      }
    }
  }
}
