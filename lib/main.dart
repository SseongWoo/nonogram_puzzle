import 'package:flutter/material.dart';
import 'package:nonogram_puzzle/components/stage_data.dart';
import 'package:nonogram_puzzle/components/stage_data_class.dart';
import 'game_board.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: GameBoard(),
      home: TestScreen(),
    );
  }
}

class TestScreen extends StatelessWidget {
  List<List<int>>? stageDataList;
  int? stageHW;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            pushData();
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => GameBoard(deliveryData: StageData(1,stageHW!,stageDataList!)),));
            //print("1 = $stageDataList 2 = $stageHW");
          },
          child: Text("next"),
        ),
      ),
    );
  }

  void pushData(){
    stageDataList = stageData[3]!;
    stageHW = stageDataList!.length;
  }
}
