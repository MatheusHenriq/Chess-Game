import 'dart:developer';

import 'package:flutter/material.dart';

class ChessBoardPage extends StatefulWidget {
  const ChessBoardPage({super.key});

  @override
  State<ChessBoardPage> createState() => _ChessBoardPageState();
}

class _ChessBoardPageState extends State<ChessBoardPage> {
  final int chessHouseNumberPerLine = 8;
  final double chessHouseArea = 42.0;

  Widget chessHouse({required bool isOdd}) {
    return Container(
      decoration: BoxDecoration(
          color: isOdd ? Colors.blue : Colors.grey.shade200,
          border: Border.all(color: Colors.black, width: 0.3)),
      height: chessHouseArea,
      child: Image.asset("assets/images/black_pawn.png"),
      width: chessHouseArea,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Chess Board"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: chessHouseNumberPerLine * chessHouseArea,
              width: chessHouseNumberPerLine * chessHouseArea,
              child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: chessHouseNumberPerLine * chessHouseNumberPerLine,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: chessHouseNumberPerLine),
                  itemBuilder: (context, index) {
                    int x = index ~/ 8;
                    int y = index % 8;
                    bool isOdd = (x + y) % 2 == 0;
                    return chessHouse(isOdd: isOdd);
                  }),
            ),
          )
        ],
      ),
    );
  }
}
