import 'package:nonogram_puzzle/stage/save_load.dart';
import 'package:nonogram_puzzle/stage/stage_custom_dialog.dart';
import 'global_variable.dart';

// 게임 클리어 조건을 검사해서 처리하는 함수
bool gameClearEvent() {
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
    stageSave(stageNumber, stageCheck, life, hint, elapsedTime, true);
    gameClearDialog(contextData);
    return true;
  }
  return false;
}

// 라이프가 다 깎였을 시 다이얼로그를 실행시켜주는 함수
void gameOverEvent() {
  gameOverDialog();
}