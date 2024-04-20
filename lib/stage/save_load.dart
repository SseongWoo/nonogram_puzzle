import '../main_menu/file_save_load.dart';

// 저장될 데이터를 저장리스트에 저장시키는 함수
void stageSave(int stageNumber, List<List<int>> stageCheck, int life, int hint, Duration time, bool clear){
  saveDataList[stageNumber] = SaveDataClass(stageCheck,life,hint,time,clear);
}

// 저장된 데이터를 저장리스트에서 불러오는 함수
SaveDataClass? stageLoad(int stageNumber){
  return saveDataList[stageNumber];
}