import 'dart:math';

import 'package:flutter/material.dart';

class ClockWindowFrame extends CustomPainter {
  final Paint framePainter;
  ClockWindowFrame() : this.framePainter = Paint();

  @override
  void paint(Canvas canvas, Size size) {

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);
    final sweep = ( 2 * pi ) * 0.75;

    framePainter.color = Colors.black;
    framePainter.style = PaintingStyle.stroke;
    framePainter.strokeWidth = 1.0;

    canvas.drawArc(rect, 0, sweep, true, framePainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return this != oldDelegate;
  }

}