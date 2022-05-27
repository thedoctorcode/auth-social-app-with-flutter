import 'dart:math';

import 'package:flutter/material.dart';
import 'package:social_appl/theme.dart';

class BubbleIndicatorPainter extends CustomPainter {
  final Paint painter;
  final double dxTarget;
  final double dxEntry;
  final double radius;
  final double dy;

  final PageController pageController;

  BubbleIndicatorPainter({
    this.dxTarget = 125,
    this.dxEntry = 25,
    this.radius = 21,
    this.dy = 25,
    required this.pageController,
  })  : painter = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill,
        super(repaint: pageController);

  @override
  void paint(Canvas canvas, Size size) {
    final entry = Offset(dxEntry, dy);
    final target = Offset(dxTarget, dy);

    final path = Path();

    path.addArc(Rect.fromCircle(center: entry, radius: radius), 0.5 * pi, pi);
    path.addRect(Rect.fromLTRB(entry.dx, dy - radius, target.dx, dy + radius));
    path.addArc(Rect.fromCircle(center: target, radius: radius), 1.5 * pi, pi);

    final pos = pageController.position;
    final fullExtent =
        pos.maxScrollExtent - pos.minScrollExtent + pos.viewportDimension;
    final pageOffset = pos.extentBefore / fullExtent;

    canvas.translate(size.width * pageOffset, 0.0);
    canvas.drawShadow(path, CustomTheme.gradientStart, 3.0, true);

    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
