import 'package:flutter/material.dart';
import 'dart:math' as math;

class RainbowLoading extends CustomPainter {
  double _scale;
  double _rotation;
  double _progress;
  Color _loadingPaintColor;
  Paint _loadingPaint;

  RainbowLoading(this._scale, this._rotation, this._progress, this._loadingPaintColor) {
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
    var canvasRotation = 0.0 * 2.25 * math.pi;
    canvas.rotate(canvasRotation);

    // Draw the shadow
    var shadowPath = Path();
    shadowPath.addOval(Rect.fromCircle(center: Offset.zero, radius: size.width / 2));
    canvas.drawShadow(shadowPath, Colors.grey[350], 10.0, true);

    // Draw the circular background
    var backgroundDiscPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset.zero, size.width / 2, backgroundDiscPaint);

    // Draw the circle arc in two phases
    // Phase 1 - For progress values from 0.0 to 0.5 we draw arcs from 0 to 2 pi radians, keeping the start angle constant
    if (_progress < 0.5) {
      double startAngle = 1.5 * math.pi;
      double sweepAngle = (2 * _progress) * 2 * math.pi;
      var arcRadius = size.width * 0.5;
      var rect = Rect.fromLTRB(-arcRadius / 2, -arcRadius / 2, arcRadius / 2, arcRadius / 2);
      canvas.drawArc(rect, startAngle, sweepAngle, false, _loadingPaint);
    }

    // Phase 2 - For progress values from 0.5 to 1.0 we draw arcs from 2 pi to 0 radians, increasing the start angle from 0 to 2 pi radians
    if (_progress >= 0.5) {
      double startAngle = 1.5 * math.pi + (2 * _progress) * 2 * math.pi;
      double sweepAngle = (1 - (2 * (_progress - 0.5))) * 2 * math.pi;
      var arcRadius = size.width * 0.5;
      var rect = Rect.fromLTRB(-arcRadius / 2, -arcRadius / 2, arcRadius / 2, arcRadius / 2);
      canvas.drawArc(rect, startAngle, sweepAngle, false, _loadingPaint);
    }
  }

  @override
  bool shouldRepaint(RainbowLoading old) {
    return old._scale != _scale
        || old._rotation != _rotation
        || old._progress != _progress
        || old._loadingPaintColor != _loadingPaintColor;
  }
}
