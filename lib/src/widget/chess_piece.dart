import 'package:chess_board/core/constants/app_images.dart';

enum ChessType {
  pawn,
  king,
  bishop,
  knight,
  rook,
  queen,
}

class ChessPiece {
  final ChessType type;
  final bool isWhite;
  final String imagePath;
  const ChessPiece(
      {required this.type, required this.isWhite, required this.imagePath});
  const ChessPiece.whitePawn(
      {this.type = ChessType.pawn,
      this.isWhite = true,
      this.imagePath = AppImages.whitePawn});
  const ChessPiece.blackPawn(
      {this.type = ChessType.pawn,
      this.isWhite = false,
      this.imagePath = AppImages.blackPawn});

  const ChessPiece.whiteBishop(
      {this.type = ChessType.bishop,
      this.isWhite = true,
      this.imagePath = AppImages.whiteBishop});
  const ChessPiece.blackBishop(
      {this.type = ChessType.bishop,
      this.isWhite = false,
      this.imagePath = AppImages.blackBishop});

  const ChessPiece.whiteRook(
      {this.type = ChessType.rook,
      this.isWhite = true,
      this.imagePath = AppImages.whiteRook});
  const ChessPiece.blackRook(
      {this.type = ChessType.rook,
      this.isWhite = false,
      this.imagePath = AppImages.blackRook});

  const ChessPiece.whiteKnight(
      {this.type = ChessType.knight,
      this.isWhite = true,
      this.imagePath = AppImages.whiteKnight});
  const ChessPiece.blackKnight(
      {this.type = ChessType.pawn,
      this.isWhite = false,
      this.imagePath = AppImages.blackKnight});

  const ChessPiece.whiteQueen(
      {this.type = ChessType.queen,
      this.isWhite = true,
      this.imagePath = AppImages.whiteQueen});
  const ChessPiece.blackQueen(
      {this.type = ChessType.queen,
      this.isWhite = false,
      this.imagePath = AppImages.blackQueen});

  const ChessPiece.whiteKing(
      {this.type = ChessType.king,
      this.isWhite = true,
      this.imagePath = AppImages.whiteKing});
  const ChessPiece.blackKing(
      {this.type = ChessType.king,
      this.isWhite = false,
      this.imagePath = AppImages.blackKing});
}
