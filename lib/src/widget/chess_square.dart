import 'package:chess_board/core/constants/app_colors.dart';
import 'package:chess_board/src/widget/chess_piece.dart';
import 'package:flutter/material.dart';

class ChessSquare extends StatelessWidget {
  final bool isColored;
  final ChessPiece? pieceType;
  final double squareHeight;
  final Function() onTap;
  final bool isSelected;
  const ChessSquare(
      {super.key,
      required this.isColored,
      required this.onTap,
      required this.isSelected,
      this.pieceType,
      required this.squareHeight});

  @override
  Widget build(BuildContext context) {
    Color? squareColor;
    if (isSelected) {
      squareColor = Colors.yellow.withValues(alpha: 0.6);
    } else {
      squareColor = isColored ? AppColors.squareColor1 : AppColors.squareColor2;
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: squareColor,
        height: squareHeight,
        width: squareHeight,
        child: pieceType != null ? Image.asset(pieceType!.imagePath) : null,
      ),
    );
  }
}
