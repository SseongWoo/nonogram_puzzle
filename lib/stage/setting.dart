import 'package:flutter/material.dart';
import 'package:nonogram_puzzle/stage/stage_custom_dialog.dart';
import '../main_menu/color_list.dart';
import 'board/mainboard.dart';
import 'board/piece_change.dart';
import 'global_variable.dart';

// 설정창을 구현하는 클래스
class SettingMenu extends StatefulWidget {
  const SettingMenu({super.key});

  @override
  State<SettingMenu> createState() => _SettingMenuState();
}

class _SettingMenuState extends State<SettingMenu> {
  TextEditingController _textEditingController = TextEditingController(text: "$selectBorder");
  bool _checkText = true;
  double _sizePercentage(int percent) {
    return (bodySize * percent) / 100;
  }

  double _sizePercentageContainer(int percent) {
    return ((bodySize * 3) * percent) / 100;
  }

  bool isNumeric(String str) {
    return double.tryParse(str) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: bodySize * 2,
      height: bodySize * 3,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey, // 그림자 색상
            spreadRadius: 5,  // 그림자 확산 범위
            blurRadius: 7,    // 그림자 흐림 정도
            offset: Offset(0, 3), // 그림자의 위치 (수평, 수직)
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _sizePercentageContainer(15),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 1.0
                  )
                )
              ),
              child: Center(
                  child: Text(
                "설정",
                style: TextStyle(
                  fontSize: _sizePercentage(20),
                ),
              )),
            ),
            Container(
              height: _sizePercentageContainer(10),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.grey,
                          width: 1.0
                      )
                  )
              ),
              child: Center(
                  child: Text(
                "난이도 : $level",
                style: TextStyle(
                  fontSize: _sizePercentage(15),
                ),
              )),
            ),
            Container(
              height: _sizePercentageContainer(10),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.grey,
                          width: 1.0
                      )
                  )
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "효과음",
                      style: TextStyle(fontSize: _sizePercentage(10)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Switch(
                          value: soundCheck,
                          onChanged: (value) {
                            setState(() {
                              soundCheck = soundCheck ? false : true;
                            });
                          },
                          activeTrackColor: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: _sizePercentageContainer(5),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.grey,
                          width: 1.0
                      )
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "효과음 음량",
                    style: TextStyle(fontSize: _sizePercentage(10)),
                  ),
                ),
              ),
            ),
            Container(
              height: _sizePercentageContainer(10),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.grey,
                          width: 1.0
                      )
                  )
              ),
              child: Slider(
                value: soundVolume,
                max: 100,
                divisions: 20,
                label: soundVolume.round().toString(),
                activeColor: Colors.blueAccent,
                onChanged: (value) {
                  setState(() {
                    soundVolume = value;
                    player.setVolume(soundVolume / 100);
                  });
                },
              ),
            ),
            Container(
              height: _sizePercentageContainer(10),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.grey,
                          width: 1.0
                      )
                  )
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "마우스 잠금",
                      style: TextStyle(fontSize: _sizePercentage(10)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Switch(
                          value: mouseEnable,
                          onChanged: (value) {
                            setState(() {
                              mouseEnable = mouseEnable ? false : true;
                            });
                          },
                          activeTrackColor: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: _sizePercentageContainer(10),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.grey,
                          width: 1.0
                      )
                  )
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "보드 색상",
                      style: TextStyle(fontSize: _sizePercentage(10)),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: DropdownButton<String>(
                        value: mainBoardColor,
                        onChanged: (String? newValue) {
                          setState(() {
                            mainBoardColor = newValue!;
                            mainBoard = initializeMainBoard();
                          });
                          loadingDialog(2);
                        },
                        items: colorMap.keys
                            .map<DropdownMenuItem<String>>((String key) {
                          return DropdownMenuItem<String>(
                            value: key,
                            child: Text(
                              key,
                              style: TextStyle(
                                  color: colorMap[key],
                                  fontSize: _sizePercentage(12)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: _sizePercentageContainer(10),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.grey,
                          width: 1.0
                      )
                  )
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "배경 색상",
                      style: TextStyle(fontSize: _sizePercentage(10)),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: DropdownButton<String>(
                        value: sideColor,
                        onChanged: (String? newValue) {
                          setState(() {
                            sideColor = newValue!;
                          });
                          loadingDialog(1);
                        },
                        items: colorMap.keys
                            .map<DropdownMenuItem<String>>((String key) {
                          return DropdownMenuItem<String>(
                            value: key,
                            child: Text(
                              key,
                              style: TextStyle(
                                  color: colorMap[key],
                                  fontSize: _sizePercentage(12)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: _sizePercentageContainer(10),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.grey,
                          width: 1.0
                      )
                  )
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "커서 색상",
                      style: TextStyle(fontSize: _sizePercentage(10)),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: DropdownButton<String>(
                        value: cursorColor,
                        onChanged: (String? newValue) {
                          setState(() {
                            cursorColor = newValue!;
                            boardPieceChange(
                                currentRow, currentCol, true, false);
                          });
                          loadingDialog(1);
                        },
                        items: colorMap.keys
                            .map<DropdownMenuItem<String>>((String key) {
                          return DropdownMenuItem<String>(
                            value: key,
                            child: Text(
                              key,
                              style: TextStyle(
                                  color: colorMap[key],
                                  fontSize: _sizePercentage(12)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: _sizePercentageContainer(10),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.grey,
                          width: 1.0
                      )
                  )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "커서 두께",
                      style: TextStyle(fontSize: _sizePercentage(10)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                      width: _sizePercentageContainer(32),
                      height: _sizePercentageContainer(8),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1.0),
                            ),
                            width: _sizePercentageContainer(8),
                            child: Center(
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if(selectBorder > 1){
                                          selectBorder -= 0.5;
                                          _textEditingController = TextEditingController(text: "$selectBorder");
                                          boardPieceChange(
                                              currentRow, currentCol, true, false);
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.remove))),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1.0),
                            ),
                            width: _sizePercentageContainer(16),
                            child: TextField(
                              style: TextStyle(fontSize: _sizePercentage(12)),
                              textAlign: TextAlign.center,
                              onSubmitted: (value) {
                                if(isNumeric(value)){
                                  double border = (double.parse(value) / 0.5).round() * 0.5;
                                  if(border >= 1 && border <= 10){
                                    setState(() {
                                      selectBorder = border;
                                      boardPieceChange(
                                          currentRow, currentCol, true, false);
                                    });
                                    _checkText = true;
                                  }
                                  else{
                                    _checkText = false;
                                  }
                                }
                                else{
                                  _checkText = false;
                                }
                                if(!_checkText){
                                  setState(() {
                                    _textEditingController = TextEditingController(text: "$selectBorder");
                                  });
                                }
                              },
                              controller: _textEditingController,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1.0),
                            ),
                            width: _sizePercentageContainer(8),
                            child: Center(
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if(selectBorder < 10){
                                          selectBorder += 0.5;
                                          _textEditingController = TextEditingController(text: "$selectBorder");
                                          boardPieceChange(
                                              currentRow, currentCol, true, false);
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.add))),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: _sizePercentageContainer(10),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.grey,
                          width: 1.0
                      )
                  )
              ),
              child: Center(
                  child: TextButton(onPressed: () {
                    setState(() {
                      soundCheck = true;
                      soundVolume = 50;
                      player.setVolume(soundVolume / 100);
                      mouseEnable = true;
                      mainBoardColor = "grey";
                      sideColor = "blueGrey";
                      cursorColor = "blue";
                      mainBoard = initializeMainBoard();
                      selectBorder = 2.0;
                      _textEditingController = TextEditingController(text: "$selectBorder");
                      boardPieceChange(
                          currentRow, currentCol, true, false);
                    });
                    loadingDialog(2);
                  }, child: Text("설정 초기화 하기",style: TextStyle(fontSize: _sizePercentage(10)),)
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
