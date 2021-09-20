import 'dart:math';

import 'package:flutter/material.dart';
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import 'package:helloworld/model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key,  required this.title}) : super(key: key);
   final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool turnOfCircle = true;
  List<PieceStatus> statusList=List.filled(9,PieceStatus.none);
  GameStatus gameStatus = GameStatus.play;
  List<Widget> buildLine = [Container()];
  double lineThickness = 6.0;
  late double lineWidth ;


  final List<List<int>> settlementListHorizonal =[
    [0,1,2],
    [3,4,5],
    [6,7,8]
  ];

  final List<List<int>> settlementListVertical =[
    [0,3,6],
    [1,4,7],
    [2,5,8]
  ];

  final List<List<int>> settlementListDiagonal =[
    [0,4,8],
    [2,4,6]
  ];


  @override
  Widget build(BuildContext context) {
    //buildに入ったタイミング出ないとMediaQueryはとってこれない
    lineWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(FontAwesomeIcons.circle,color: Colors.green, size: 30),
            Icon(Icons.clear,color: Colors.red, size: 30),
            Text("ゲーム")
          ],
        ),
      ),
      body:Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildText(),
                OutlineButton(
                  child:Text("クリア"),
                  onPressed: () {
                    setState(() {
                      turnOfCircle = true;
                      statusList = List.filled(9,PieceStatus.none);
                      gameStatus = GameStatus.play;
                       buildLine = [Container()];
                    });
                  },
                )
              ],
            ),
          ),
          buildField()
        ],
      ),

    );
  }

  Widget buildText() {
    switch(gameStatus){
      case GameStatus.play:
        return Row(
          children:  [
            turnOfCircle? Icon(FontAwesomeIcons.circle):Icon(Icons.clear),
            Text("の番です"),
          ],
        );
        break;
        case GameStatus.draw:
          return Text("引き分けです");
          break;
      case GameStatus.settlement:
        return Row(
          children:  [
            !turnOfCircle? Icon(FontAwesomeIcons.circle):Icon(Icons.clear),
            Text("の勝ちです"),
          ],
        );
        break;
        default:
          return Container();
    }

  }

  Widget buildField() {
    List<Widget> _columnCildren = [Divider(height: 0.0,color: Colors.black,)];
    List<Widget> _rowCildren = [];

    for(int j=0; j<3; j++){
      for(int i = 0; i < 3; i++){
        int _index = j * 3 + i;
        _rowCildren.add(
            Expanded(
              child:InkWell(
                onTap:gameStatus == GameStatus.play ? (){
                  if(statusList[_index] == PieceStatus.none) {
                    statusList[_index] = turnOfCircle ? PieceStatus.circle : PieceStatus.cross;
                    turnOfCircle = !turnOfCircle;
                    confirmResult();
                  }
                  setState(() {

                  });
              } :null ,
                child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Row(
                      children: [
                        Expanded(
                          child: buildContainer(statusList[_index]),
                        ),
                        (i ==2)?Container():VerticalDivider(width:0.0,color:Colors.black),
          ],
                    )

                    ),
              ),
            )
        );
      }
      _columnCildren.add(Row(children: _rowCildren,));
      _columnCildren.add(Divider(height: 0.0,color:Colors.black));
      _rowCildren = [];
    }

    return Stack(
      children: [
        Column(children: _columnCildren,),
        Stack(
          children: buildLine,

        )
      ],
    );
  }

  Container buildContainer(PieceStatus pierceStatus) {
    switch(pierceStatus){
      case PieceStatus.none:
        return Container();
        break;
      case PieceStatus.circle:
          return Container(
            child:Icon(FontAwesomeIcons.circle,size:60,color:Colors.blue),
          );
          break;
      case PieceStatus.cross:
        return Container(
          child:Icon(Icons.clear,size:60,color:Colors.red),
        );
        break;
      default:
        return Container();
    }

  }

  void confirmResult(){
    if(!statusList.contains(PieceStatus.none)){
      gameStatus = GameStatus.draw;
    }
    for(int i =0; i < settlementListHorizonal.length; i++){
      if(statusList[settlementListHorizonal[i][0]]== statusList[settlementListHorizonal[i][1]] && statusList[settlementListHorizonal[i][1]] == statusList[settlementListHorizonal[i][2]]&& statusList[settlementListHorizonal[i][0]]!= PieceStatus.none){
        buildLine.add(
          Container(
            width: lineWidth,
            height: lineThickness,
            color: Colors.black.withOpacity(0.3),
            margin:EdgeInsets.only(top: lineWidth / 3 * i + lineWidth / 6 - lineThickness / 2),
          )
        );
        gameStatus = GameStatus.settlement;
        // showDialog(
        //   context: context,
        //   barrierDismissible: false,
        //   builder: (_) {
        //     return AlertDialog(
        //       title: Text("プレゼントです！！！"),
        //       content: Image.network('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
        //       actions: [
        //         FlatButton(
        //           child: Text("ありがとう"),
        //           onPressed: () =>
        //           setState(() {
        //             turnOfCircle = true;
        //             statusList = List.filled(9,PieceStatus.none);
        //             gameStatus = GameStatus.play;
        //             buildLine = [Container()];
        //             Navigator.pop(context);
        //            })
        //         ),
        //       ],
        //     );
        //   },
        // );
      }
    }
    for(int i =0; i < settlementListVertical.length; i++){
      if(statusList[settlementListVertical[i][0]]== statusList[settlementListVertical[i][1]] && statusList[settlementListVertical[i][1]] == statusList[settlementListVertical[i][2]]&& statusList[settlementListVertical[i][0]]!= PieceStatus.none){
        buildLine.add(
            Container(
              width: lineThickness,
              height: lineWidth,
              color: Colors.black.withOpacity(0.3),
              margin:EdgeInsets.only(left: lineWidth / 3 * i + lineWidth / 6 - lineThickness / 2),
            )
        );
        gameStatus = GameStatus.settlement;

      }
    }
    for(int i =0; i < settlementListDiagonal.length; i++){
      if(statusList[settlementListDiagonal[i][0]]== statusList[settlementListDiagonal[i][1]] && statusList[settlementListDiagonal[i][1]] == statusList[settlementListDiagonal[i][2]]&& statusList[settlementListDiagonal[i][0]]!= PieceStatus.none){
        buildLine.add(
          Transform.rotate(
              alignment: i == 0 ? Alignment.topLeft:Alignment.topRight,
              angle: i == 0 ? -pi / 4: pi / 4,
            child:Container(
            width: lineThickness,
            height: lineWidth * sqrt(2),
              color: Colors.black.withOpacity(0.3),
              margin: EdgeInsets.only(left: i == 0 ? 0.0 : lineWidth - lineThickness),
          ))
        );
        gameStatus = GameStatus.settlement;
      }
    }
  }
}

