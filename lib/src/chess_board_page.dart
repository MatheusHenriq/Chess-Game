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
  List<List<int>> validMoves = [];
  List<ChessPiece> whitePiecesCaptured = [];
  List<ChessPiece> blackPiecesCaptured = [];
  bool isWhiteTurn = true;
  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0, 4];
  bool checkStatus = false;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  bool isInBoard({required int row, required int col}) {
    return row >= 0 && row < 8 && col >= 0 && col < 8;
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
      isWhiteTurn = true;
    });
  }

  void pieceSelected({required int row, required int col}) {
    setState(() {
      //No piece has been selected yer, this is the first selection
      if (selectedPiece == null && board[row][col] != null) {
        if (board[row][col]!.isWhite == isWhiteTurn) {
          selectedPiece = board[row][col];
          selectedRow = row;
          selectedCol = col;
        }
      }

      //There is a piece already selected, but user can select another one of their pieces
      else if (board[row][col] != null &&
          board[row][col]!.isWhite == selectedPiece!.isWhite) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }

      // if there is a piece selected, and user click on a house that is a valid move, move piece there
      else if (selectedPiece != null &&
          validMoves.any((element) => element[0] == row && element[1] == col)) {
        movePiece(newRow: row, newCol: col);
      }
      // if a piece is selected, calculate its valid moves
      validMoves =
          calculateRowValidMoves(row: row, col: col, piece: board[row][col]);
    });
  }

  List<List<int>> calculateRowValidMoves(
      {required int row, required int col, ChessPiece? piece}) {
    List<List<int>> candidateMoves = [];
    if (piece != null) {
      switch (piece.type) {
        case ChessType.pawn:
          int direction = piece.isWhite ? -1 : 1;

          //pawns can move fowared if the house is not occupied
          if (isInBoard(row: row + direction, col: col) &&
              board[row + direction][col] == null) {
            candidateMoves.add([row + direction, col]);
          }

          //pawns can move 2 houses fowared if they are in the initial positions and do not have any piece in that space
          if (((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) &&
              isInBoard(row: row + 2 * direction, col: col) &&
              board[row + direction][col] == null &&
              board[row + 2 * direction][col] == null) {
            candidateMoves.add([row + 2 * direction, col]);
          }

          //pawns can capture diagonally
          if (isInBoard(row: row + direction, col: col - 1) &&
              board[row + direction][col - 1] != null &&
              board[row + direction][col - 1]!.isWhite != piece.isWhite) {
            candidateMoves.add([row + direction, col - 1]);
          }
          if (isInBoard(row: row + direction, col: col + 1) &&
              board[row + direction][col + 1] != null &&
              board[row + direction][col + 1]!.isWhite) {
            candidateMoves.add([row + direction, col + 1]);
          }
          break;
        case ChessType.king:
          var directions = [
            [-1, 0], // up
            [1, 0], // down
            [0, -1], //left
            [0, 1], //right,
            [1, 1], //down right
            [1, -1], //down left
            [-1, 1], //up right
            [-1, -1] // up left
          ];
          for (var direction in directions) {
            var newRow = row + direction[0];
            var newCol = col + direction[1];
            if (!isInBoard(row: newRow, col: newCol)) {
              continue;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]); // kill
              }
              continue;
            }
            candidateMoves.add([newRow, newCol]);
          }
          break;
        case ChessType.bishop:
          var directions = [
            [-1, -1], // up left
            [1, 1], //down right
            [1, -1], //down left
            [-1, 1], //up right
          ];
          for (var direction in directions) {
            var i = 1;
            while (true) {
              var newRow = row + i * direction[0];
              var newCol = col + i * direction[1];
              if (!isInBoard(row: newRow, col: newCol)) {
                break;
              }
              if (board[newRow][newCol] != null) {
                if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                  candidateMoves.add([newRow, newCol]); //kill
                }
                break;
              }
              candidateMoves.add([newRow, newCol]);
              i++;
            }
          }
          break;
        case ChessType.knight:
          var knightMoves = [
            [-2, -1], // up 2 left 1
            [-2, 1], //up 2 right 1
            [-1, -2], // up 1 left 2
            [-1, 2], // up 1 right 2
            [1, -2], // down 1 left 2
            [1, 2], // down 1 right 2
            [2, -1], // down 2 left 1
            [2, 1], // down 2 right 1
          ];
          for (var move in knightMoves) {
            var newRow = row + move[0];
            var newCol = col + move[1];
            if (!isInBoard(row: newRow, col: newCol)) {
              continue;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]); // kill
              }
              continue; //blocked
            }
            candidateMoves.add([newRow, newCol]);
          }

          break;
        case ChessType.rook:
          var directions = [
            [-1, 0], // goes up
            [1, 0], // goes down
            [0, -1], // goes left
            [0, 1], // goes right
          ];
          // horizontal and vertical diretions
          for (var direction in directions) {
            int i = 1;
            while (true) {
              var newRow = row + i * direction[0];
              var newCol = col + i * direction[1];
              if (!isInBoard(row: newRow, col: newCol)) {
                break;
              }
              if (board[newRow][newCol] != null) {
                if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                  candidateMoves.add([newRow, newCol]); //kill
                }
                break; // blocked
              }
              candidateMoves.add([newRow, newCol]);
              i++;
            }
          }
          break;
        case ChessType.queen:
          var directions = [
            [-1, 0], // up
            [1, 0], // down
            [0, -1], //left
            [0, 1], //right,
            [1, 1], //down right
            [1, -1], //down left
            [-1, 1], //up right
            [-1, -1] // up left
          ];
          for (var direction in directions) {
            var i = 1;
            while (true) {
              var newRow = row + i * direction[0];
              var newCol = col + i * direction[1];
              if (!isInBoard(row: newRow, col: newCol)) {
                break;
              }
              if (board[newRow][newCol] != null) {
                if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                  candidateMoves.add([newRow, newCol]); //kill
                }
                break;
              }
              candidateMoves.add([newRow, newCol]);
              i++;
            }
          }
          break;
      }
    }

    return candidateMoves;
  }

  bool kingIsInCheck({required bool isWhiteKing}) {
    List<int> kingPosition =
        isWhiteKing ? whiteKingPosition : blackKingPosition;

    for (var i = 0; i < 8; i++) {
      for (var j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.isWhite == isWhiteKing) {
          continue;
        }
        List<List<int>> pieceValidMoves =
            calculateRowValidMoves(row: i, col: j, piece: board[i][j]);

        if (pieceValidMoves.any((move) =>
            move[0] == kingPosition[0] && move[1] == kingPosition[1])) {
          return true;
        }
      }
    }
    return false;
  }

  void movePiece({required int newRow, required int newCol}) {
    //if the new house has an enemy piece
    if (board[newRow][newCol] != null) {
      var capturePiece = board[newRow][newCol];
      if (capturePiece!.isWhite) {
        whitePiecesCaptured.add(capturePiece);
      } else {
        blackPiecesCaptured.add(capturePiece);
      }
    }
    //move the piece and clear the old place
    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;

    //see if any kings is under attack
    if (kingIsInCheck(isWhiteKing: !isWhiteTurn)) {
      checkStatus = true;
    } else {
      checkStatus = false;
    }

//clear selection
    setState(() {
      selectedPiece = null;
      selectedCol = -1;
      selectedRow = -1;
      validMoves = [];
    });
    isWhiteTurn = !isWhiteTurn;
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
          SizedBox(
            height: 124,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: blackPiecesCaptured.length,
              itemBuilder: (context, index) => SizedBox(
                  width: 32,
                  height: 32,
                  child: Image.asset(blackPiecesCaptured[index].imagePath)),
            ),
          ),
          Text(checkStatus ? "King Is under attack" : ""),
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
                    bool isValidMove = false;
                    for (var position in validMoves) {
                      if (position[0] == row && position[1] == col) {
                        isValidMove = true;
                      }
                    }
                    return ChessSquare(
                        isValidMove: isValidMove,
                        onTap: () => pieceSelected(row: row, col: col),
                        isSelected: isSelected,
                        isColored: isColored,
                        pieceType: board[row][col],
                        squareHeight: chessHouseArea);
                  }),
            ),
          ),
          SizedBox(
            height: 124,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: whitePiecesCaptured.length,
              itemBuilder: (context, index) => SizedBox(
                width: 32,
                height: 32,
                child: Image.asset(whitePiecesCaptured[index].imagePath),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
