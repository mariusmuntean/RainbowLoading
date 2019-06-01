import 'package:flutter/material.dart';
import 'dart:math' as math;

class RainbowLoading extends CustomPainter {
  double _progress;
  Color _loadingPaintColor;
  Paint _loadingPaint;
  double _scale;

  RainbowLoading(this._progress, this._loadingPaintColor, this._scale) {
    _loadingPaint = new Paint()
      ..strokeWidth = 7.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..color = _loadingPaintColor;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Translate to the center of the canvas and apply all transforms relative ot the center
    canvas.translate(size.width / 2.0, size.height / 2.0);

    // Scale the canvas
    canvas.scale(_scale);

    // Rotate the canvas around its center
    canvas.rotate(_progress * 2 * math.pi);

    // Draw the shadow
    var shadowPath = Path();
    shadowPath.addOval(Rect.fromCircle(center: Offset.zero, radius: size.width / 2));
    canvas.drawShadow(shadowPath, Colors.grey[350], 10.0, true);

    // Draw the circular background
    var backgroundDiscPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset.zero, size.width / 2, backgroundDiscPaint);

    // Draw the circle arc
    double startAngle = 1.5 * math.pi;
    double sweepAngle = _progress * 2 * math.pi;
    var arcRadius = size.width * 0.5;
    var rect = Rect.fromLTRB(-arcRadius / 2, -arcRadius / 2, arcRadius / 2, arcRadius / 2);
    canvas.drawArc(rect, startAngle, sweepAngle, false, _loadingPaint);
  }

  @override
  bool shouldRepaint(RainbowLoading old) {
    return old._progress != _progress || old._loadingPaintColor != _loadingPaintColor;
  }
}
