import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

Map<int,SaveDataClass> saveDataList = {};

// 스테이지 데이터 클래스
class SaveDataClass {
  late List<List<int>> stageCheck;    //사용자 보드 데이터
  late int life;                      //생명 개수
  late int hint;                      //힌트 개수
  late Duration time;                 //시간
  late bool clear;                    //클리어 여부

  SaveDataClass(
      this.stageCheck,
      this.life,
      this.hint,
      this.time,
      this.clear,
      );

  Map<String, dynamic> toJson() {
    return {
      'stageCheck': stageCheck,
      'life': life,
      'hint': hint,
      'time': time.inMilliseconds,
      'clear': clear,
    };
  }

  factory SaveDataClass.fromJson(Map<String, dynamic> json) {
    return SaveDataClass(
      List<List<int>>.from(json['stageCheck']),
      json['life'],
      json['hint'],
      Duration(milliseconds: json['time']),
      json['clear'],
    );
  }
}

// 파일 불러오기
Future<Map<int, SaveDataClass>> readDataListFromFile() async {
  try {
    final file = File('saved_data.json');
    if (!await file.exists()) {
      print('File does not exist');
      return {};
    }

    final jsonString = await file.readAsString();
    final Map<String, dynamic> jsonData = jsonDecode(jsonString);

    final Map<int, SaveDataClass> data = {};
    jsonData.forEach((key, value) {
      final int mapKey = int.tryParse(key) ?? 0;
      final SaveDataClass saveData = SaveDataClass.fromJson(value);
      data[mapKey] = saveData;
    });

    print('Data read from file');
    return data;
  } catch (e) {
    print('Error reading data: $e');
    return {};
  }
}

//파일 저장
void saveDataListToFile(Map<int, SaveDataClass> data) async {
  try {
    final file = File('saved_data.json');
    Map<String, dynamic> jsonData = {};
    data.forEach((key, value) {
      jsonData[key.toString()] = value.toJson();
    });
    await file.writeAsString(jsonEncode(jsonData));
    print('Data saved to file');
  } catch (e) {
    print('Error saving data: $e');
  }
}

//파일 선택 다이얼로그를 띄워서 파일의 위치를 가져옴
void openFilePickerAndProcessData() async {
  final result = await FilePicker.platform.pickFiles();
  if (result != null) {
    final filePath = result.files.single.path!;
    print('Selected file: $filePath');
    final data = await readDataListFromFile();
    print('Data from file: $data');
  }
}