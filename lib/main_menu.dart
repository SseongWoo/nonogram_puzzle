import 'package:flutter/material.dart';
import 'package:nonogram_puzzle/main_menu/menu_class.dart';
import 'package:nonogram_puzzle/stage.dart';
import 'package:nonogram_puzzle/stage/save_load.dart';
import 'package:nonogram_puzzle/stage_data.dart';
import 'main_menu/file_save_load.dart';
import 'main_menu/menu_custom_dialog.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  late Size screenSize;

  double heightPer(double per){return (screenSize.height * per)/100;}
  double widthPer(double per){return (screenSize.width * per)/100;}
  double sizeRate(double per){
    if(screenSize.height*2.2 > screenSize.width){
      return widthPer(per);
    }else{
      return screenSize.height/1.7;
    }
  }
  double sizeRateWidget(double per){
    if(screenSize.height*2.2 > screenSize.width){
      return widthPer(per);
    }else{
      return heightPer(per)*2.2;
    }
  }
  double sizeRateContainer(double per){
    if(screenSize.height*2.2 > screenSize.width){
      return widthPer(per);
    }else{
      return heightPer(per)*1.8;
    }
  }

  String checkLevel(int len) {
    if (len <= 10) {
      return "Easy";
    } else if (len <= 15) {
      return "Normal";
    } else {
      return "Hard";
    }
  }

  List<List<Widget?>> buildGridView(
      List<List<int>>? stageGridItem, int stageSize) {
    List<List<Widget?>> newGridView = List.generate(
        stageSize,
        (index) => List.generate(
              stageSize,
              (index) => null,
            ));
    for (int col = 0; col < stageSize; col++) {
      for (int row = 0; row < stageSize; row++) {
        if (stageGridItem?[col][row] != 0) {
          newGridView[col][row] = Container(
            color: Colors.black,
          );
        } else {
          newGridView[col][row] = Container(
            color: Colors.white,
          );
        }
      }
    }
    return newGridView;
  }

  Container menuContainerItem(int index, Size size) {
    int stageNum = index + 1;
    List<List<int>>? stageGridItem = stageData[stageNum];
    int stageSize = stageGridItem!.length;
    List<List<Widget?>> gridView = buildGridView(stageGridItem, stageSize);
    SaveDataClass? saveData;
    if (saveDataList.containsKey(stageNum)) {
      saveData = stageLoad(stageNum);
    } else {
      saveData = null;
    }

    StageDataClass stageDataCollection = StageDataClass(
        stageNum, stageGridItem, checkLevel(stageSize), saveData);

    return Container(
      width: sizeRate(25),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: sizeRateWidget(1),
            ),
            Text(
              "Stage $stageNum",
              style: TextStyle(
                fontSize: sizeRateWidget(4),
              ),
            ), //임시 타이틀
            SizedBox(
              height: sizeRateWidget(1),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white,
                width: sizeRateContainer(20),
                height: sizeRateContainer(20),
                child: saveData == null || saveData.clear == false
                    ? Center(
                        child: Text(
                          "?",
                          style: TextStyle(
                            fontSize: sizeRateWidget(6),
                          ),
                        ),
                      )
                    : GridView.builder(
                        itemCount: stageSize * stageSize,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: stageSize),
                        itemBuilder: (context, index) {
                          int col = index ~/ stageSize;
                          int row = index % stageSize;
                          return gridView[col][row];
                        },
                      ),
              ),
            ),
            SizedBox(
              height: sizeRateWidget(1),
            ),
            Text(
              "스테이지 크기 : $stageSize * $stageSize",
              style: TextStyle(
                fontSize: sizeRateWidget(2),
              ),
            ),
            SizedBox(
              height: sizeRateWidget(1),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: (size.width * 2) / 100),
              child: SizedBox(
                height: sizeRateWidget(4.5),
                width: size.width,
                child: OutlinedButton(onPressed: () {
                  if(saveData == null){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => GameBoard(deliveryData: stageDataCollection)))
                        .then((value) {
                      setState(() {});
                    });
                  }else if(!saveData.clear){
                    stageSelectDialog(context, stageDataCollection);    //클리어x 세이브x 인 지역을 선택할때
                  }else{
                    stageSelectDialog2(context,stageDataCollection);    //클리어한 지역을 선택할때
                  }
        
                }, child: Text("시작하기",style: TextStyle(fontSize: sizeRateWidget(2)),)),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: const Text("스테이지 선택"),
        centerTitle: true,
        actions: [
          IconButton(
              tooltip: "불러오기",
              onPressed: () {
                openFilePickerAndProcessData();
          }, icon: const Icon(Icons.file_download)),
          IconButton(
              tooltip: "저장하기",
              onPressed: () {
                if(saveDataList.isNotEmpty){
                  saveDataListToFile(saveDataList);
                }else{
                  fileSaveDialog(context);
                }
          }, icon: const Icon(Icons.file_upload)),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: screenSize.width,
          height: screenSize.height*2.3 > screenSize.width ? (screenSize.width * 40) / 100 : screenSize.height,
          child: ScrollConfiguration(
            behavior: MyCustomScrollBehavior(),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: stageData.length,
              padding: EdgeInsets.symmetric(
                  horizontal: (screenSize.width * 35) / 100),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB((screenSize.width*2.5)/100, 0, (screenSize.width*2.5)/100, 0),
                  child: menuContainerItem(index, screenSize),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
