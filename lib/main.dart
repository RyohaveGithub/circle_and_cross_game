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

  @override
  Widget build(BuildContext context) {
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
                Row(
                  children:  [
                    turnOfCircle? Icon(FontAwesomeIcons.circle):Icon(Icons.clear),
                    Text("の番です"),
                  ],
                ),
                OutlineButton(
                  child:Text("クリア"),
                  onPressed: () {

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

  Column buildField() {
    List<Widget> _columnCildren = [Divider(height: 0.0,color: Colors.black,)];
    List<Widget> _rowCildren = [];

    for(int j=0; j<3; j++){
      for(int i = 0; i < 3; i++){
        int _index = j * 3 + i;
        _rowCildren.add(
            Expanded(
              child:InkWell(
                onTap:(){
                  if(statusList[_index] == PieceStatus.none) {
                    statusList[_index] = turnOfCircle ? PieceStatus.circle : PieceStatus.cross;
                    turnOfCircle = !turnOfCircle;
                  }
                  setState(() {

                  });
              },
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

    return Column(children: _columnCildren,);
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
}

