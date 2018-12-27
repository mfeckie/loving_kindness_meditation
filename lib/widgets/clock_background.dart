import 'dart:math';

import 'package:flutter/material.dart';

class ClockBackground extends CustomPainter {
  final Paint clockBackgroundPainter;
  ClockBackground() : this.clockBackgroundPainter = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    clockBackgroundPainter.color = Colors.blue;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final quarter = (2 * pi) * 0.25;
    canvas.drawArc(rect, 0, quarter, true, clockBackgroundPainter);
    clockBackgroundPainter.color = Colors.teal;

    canvas.drawArc(rect, quarter, quarter, true, clockBackgroundPainter);

    clockBackgroundPainter.color = Colors.purple;

    canvas.drawArc(rect, quarter * 2, quarter, true, clockBackgroundPainter);

    clockBackgroundPainter.color = Colors.yellow;

    canvas.drawArc(rect, quarter * 3, quarter, true, clockBackgroundPainter);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
