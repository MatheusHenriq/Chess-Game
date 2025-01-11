import 'package:chess_board/src/widget/chess_piece.dart';
import 'package:chess_board/src/widget/chess_square.dart';
import 'package:flutter/material.dart';

class ChessBoardPage extends StatefulWidget {
  const ChessBoardPage({super.key});

  @override
  State<ChessBoardPage> createState() => _ChessBoardPageState();
}

class _ChessBoardPageState extends State<ChessBoardPage> {
  final int chessHouseNumberPerLine = 8;
  final double chessHouseArea = 42.0;
  late List<List<ChessPiece?>> board;
  ChessPiece? selectedPiece;
  int selectedRow = -1;
  int selectedCol = -1;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  void _initializeBoard() {
    List<List<ChessPiece?>> newBoard = List.generate(
      chessHouseNumberPerLine,
      (index) => List.generate(chessHouseNumberPerLine, (index) => null),
    );

    //Place Pawns
    for (var i = 0; i < chessHouseNumberPerLine; i++) {
      newBoard[1][i] = ChessPiece.blackPawn();
    }
    for (var i = 0; i < chessHouseNumberPerLine; i++) {
      newBoard[6][i] = ChessPiece.whitePawn();
    }
    //Place Rooks
    newBoard[0][0] = ChessPiece.blackRook();
    newBoard[0][7] = ChessPiece.blackRook();
    newBoard[7][0] = ChessPiece.whiteRook();
    newBoard[7][7] = ChessPiece.whiteRook();
    //Place Knights
    newBoard[0][1] = ChessPiece.blackKnight();
    newBoard[0][6] = ChessPiece.blackKnight();
    newBoard[7][1] = ChessPiece.whiteKnight();
    newBoard[7][6] = ChessPiece.whiteKnight();
    //Place Bishops
    newBoard[0][2] = ChessPiece.blackBishop();
    newBoard[0][5] = ChessPiece.blackBishop();
    newBoard[7][2] = ChessPiece.whiteBishop();
    newBoard[7][5] = ChessPiece.whiteBishop();
    //Place Queens
    newBoard[0][3] = ChessPiece.blackQueen();
    newBoard[7][3] = ChessPiece.whiteQueen();
    //Place Kings
    newBoard[0][4] = ChessPiece.blackKing();
    newBoard[7][4] = ChessPiece.whiteKing();
    setState(() {
      board = newBoard;
    });
  }

  void pieceSelected({required int row, required int col}) {
    setState(() {
      if (board[row][col] != null) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          FloatingActionButton(onPressed: () => _initializeBoard()),
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
                    int row = index ~/ 8;
                    int col = index % 8;
                    bool isColored = (row + col) % 2 == 0;
                    bool isSelected =
                        (selectedRow == row && selectedCol == col);
                    return ChessSquare(
                        onTap: () => pieceSelected(row: row, col: col),
                        isSelected: isSelected,
                        isColored: isColored,
                        pieceType: board[row][col],
                        squareHeight: chessHouseArea);
                  }),
            ),
          )
        ],
      ),
    );
  }
}
