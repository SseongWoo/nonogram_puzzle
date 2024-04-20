import 'package:flutter/material.dart';
import 'package:nonogram_puzzle/stage/board/piece_change.dart';
import 'board/mainboard.dart';
import 'class_collection.dart';
import 'stage_custom_dialog.dart';
import 'global_variable.dart';

// 힌트를 보여주는 함수
void getHint() {
  List<UncheckedBoardListClass>? unCheckedList = uncheckedBoardList(0);
  int randomHint1, randomHint2;
  if (hint > 0 && unCheckedList != null) {
    hint--;
    randomHint1 = random.nextInt(unCheckedList.length);
    while (true) {
      randomHint2 = random.nextInt(unCheckedList.length);
      if (randomHint1 != randomHint2) break;
    }
    stageCheck[unCheckedList[randomHint1].row][unCheckedList[randomHint1].col] =
        3;
    boardPieceChange(unCheckedList[randomHint1].row,
        unCheckedList[randomHint1].col, false, false);
    stageCheck[unCheckedList[randomHint2].row][unCheckedList[randomHint2].col] =
        3;
    boardPieceChange(unCheckedList[randomHint2].row,
        unCheckedList[randomHint2].col, false, false);
  } else {
    hintDialog(contextData, hint == 0 ? true : false);
  }
}

// 스크린 크기를 참조하여 크기를 정해주는 함수
double getScreeningSize(Size size) {
  double minSize = 600;
  if (size.width - 340 < size.height - 20) {
    if (size.width - 340 > minSize) {
      return ((size.width - 340)).roundToDouble();
    } else {
      return minSize;
    }
  } else {
    if (size.height - 20 > minSize) {
      return (size.height - 20).roundToDouble();
    } else {
      return minSize;
    }
  }
}

// 시간초를 보여주는 함수
String formatTime(Duration duration) {
  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);
  int seconds = duration.inSeconds.remainder(60);

  if (hours == 0) {
    if (minutes == 0) {
      return "$seconds초";
    } else {
      return "$minutes분 $seconds초";
    }
  } else {
    return "$hours시간 $minutes분 $seconds초";
  }
}

// 시간을 초기화 하는 함수
void timeEnd() {
  stopwatch.reset();
  timeSwitch.cancel();
  stopwatchText = "0초";
}

// 사운드를 재생하는 함수
Future<void> playSound(int soundList) async {
  try {
    if (soundCheck) {
      await player.pause();
      switch (soundList) {
        case 0: // 클릭 사운드
          await player.setAsset("assets/sound/ClickSound.wav");
          break;
        case 1: // 이동 사운드
          await player.setAsset("assets/sound/MoveSound.wav");
          break;
        case 2: // 성공 사운드
          await player.setAsset("assets/sound/SuccessSound.wav");
          break;
        case 3: // 오답 사운드
          await player.setAsset("assets/sound/WrongSound.wav");
          break;
        case 4: // 실패 사운드
          await player.setAsset("assets/sound/FailSound.wav");
          break;
      }
    }
    await player.play();
  } catch (e) {
    // 오류 처리
    print("오디오 재생 중 오류 발생: $e");
    // 필요한 경우 다른 작업 수행
  }
}
