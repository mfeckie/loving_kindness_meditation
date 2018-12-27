import 'dart:math';

import 'package:flutter/material.dart';

class ClockWindow extends CustomPainter {
  final Paint clockWindowPainter;
  ClockWindow() : this.clockWindowPainter = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);
    final sweep = ( 2 * pi ) * 0.75;

    clockWindowPainter.color = Colors.white;
    canvas.drawArc(rect, 0, sweep, true, clockWindowPainter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return this != oldDelegate;
  }

}