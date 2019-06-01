import 'package:flutter/material.dart';

import 'RanbowLoading.dart';

class RainbowLoadingWidget extends StatefulWidget {
  RainbowLoadingWidgetState _rainbowLoadingWidgetState;

  @override
  State<StatefulWidget> createState() {
    _rainbowLoadingWidgetState = RainbowLoadingWidgetState();
    return _rainbowLoadingWidgetState;
  }

  void start() {
    _rainbowLoadingWidgetState?.start();
  }

  void stop() {
    _rainbowLoadingWidgetState?.stop();
  }
}

class RainbowLoadingWidgetState extends State<RainbowLoadingWidget> with TickerProviderStateMixin {
  final List<Color> _loadingColors = [Color.fromARGB(255, 66, 133, 244), Color.fromARGB(255, 219, 68, 55), Color.fromARGB(255, 244, 160, 0), Color.fromARGB(255, 15, 157, 88)];
  final Duration _arcAndRotationAnimationDuration = Duration(milliseconds: 1500);
  final double _animationStartValue = 0.0;
  final double _animationEndValue = 1.0;

  AnimationController _arcAndRotationAnimationController;
  AnimationController _scaleAnimationController;
  Animation<double> _arcAndRotationAnimation;
  Animation<double> _scaleAnimation;

  double _progress;
  double _scale;

  int _currentColorIndex;
  Color _currentColor;

  @override
  void initState() {
    super.initState();

    _scale = 0.0;
    _progress = 0.0;
    _currentColorIndex = 0;
    _currentColor = _loadingColors[_currentColorIndex];

    _arcAndRotationAnimationController = new AnimationController(vsync: this, duration: _arcAndRotationAnimationDuration);

    var curveAnimation = CurvedAnimation(parent: _arcAndRotationAnimationController, curve: Curves.easeInOutCubic);
    _arcAndRotationAnimation = Tween(begin: _animationStartValue, end: _animationEndValue).animate(curveAnimation)
      ..addListener(() {
        setState(() {
          _progress = _arcAndRotationAnimation.value;
        });
      });
    _arcAndRotationAnimationController.addStatusListener((status) {
      //print("arc animation status: $status");
      if (status == AnimationStatus.completed) {
        // Switch current color
        _currentColorIndex = _currentColorIndex + 1 >= _loadingColors.length ? 0 : _currentColorIndex + 1;
        _currentColor = _loadingColors[_currentColorIndex];

        // Repeat the animation
        _arcAndRotationAnimationController.forward(from: 0.0);
      }
    });

    _scaleAnimationController = new AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _scaleAnimation = Tween(begin: 0.0, end: 1.0).animate(_scaleAnimationController)
      ..addListener(() {
        setState(() {
          _scale = _scaleAnimation.value;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RainbowLoading(_progress, _currentColor, _scale),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _scaleAnimationController.dispose();
    _arcAndRotationAnimationController.dispose();
  }

  void start() {
    _scaleAnimationController.forward(from: _animationStartValue);
    _arcAndRotationAnimationController.forward(from: _animationStartValue);
  }

  void stop() {
    _scaleAnimationController.reverse(from: 1.0).then((val) {
      _scaleAnimationController.stop(canceled: false);
      _arcAndRotationAnimationController.stop(canceled: false);
    });
  }
}
