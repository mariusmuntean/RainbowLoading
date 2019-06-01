import 'package:flutter/material.dart';

import 'RanbowLoading.dart';

class RainbowLoadingWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RainbowLoadingWidgetState();
}

class RainbowLoadingWidgetState extends State<RainbowLoadingWidget> with TickerProviderStateMixin {
  final List<Color> _loadingColors = [Color.fromARGB(255, 66, 133, 244), Color.fromARGB(255, 219, 68, 55), Color.fromARGB(255, 244, 160, 0), Color.fromARGB(255, 15, 157, 88)];
  final Duration animationDuration = Duration(milliseconds: 1200);
  final double animationStartValue = 0.0;
  final double animationEndValue = 1.0;

  AnimationController arcAndRotationAnimationController;
  AnimationController scaleAnimationController;
  Animation<double> arcAndRotationAnimation;
  Animation<double> scaleAnimation;

  double progress;
  double _scale;

  int _currentColorIndex;
  Color currentColor;

  @override
  void initState() {
    super.initState();

    _scale = 0.0;
    progress = 0.0;
    _currentColorIndex = 0;
    currentColor = _loadingColors[_currentColorIndex];

    arcAndRotationAnimationController = new AnimationController(vsync: this, duration: animationDuration);

    var curveAnimation = CurvedAnimation(parent: arcAndRotationAnimationController, curve: Curves.easeInOut);
    arcAndRotationAnimation = Tween(begin: animationStartValue, end: animationEndValue).animate(curveAnimation)
      ..addListener(() {
        setState(() {
          progress = arcAndRotationAnimation.value;
        });
      });
    arcAndRotationAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Switch current color
        _currentColorIndex = _currentColorIndex + 1 >= _loadingColors.length ? 0 : _currentColorIndex + 1;
        currentColor = _loadingColors[_currentColorIndex];

        // Repeat the animation
        arcAndRotationAnimationController.forward(from: 0.0);
      }
    });

    scaleAnimationController = new AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    scaleAnimation = Tween(begin: 0.0, end: 1.0).animate(scaleAnimationController)
    ..addListener((){
      setState(() {
        _scale = scaleAnimation.value;
      });
    });

    scaleAnimationController.forward();
    arcAndRotationAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RainbowLoading(progress, currentColor, _scale),
    );
  }
}
