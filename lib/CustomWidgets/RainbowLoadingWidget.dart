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

  final _arcAnimationDuration = Duration(milliseconds: 1300);
  final _rotationAnimationDuration = Duration(milliseconds: 1500);
  final _scaleAnimationDuration = Duration(milliseconds: 800);

  final _arcAnimationStartValue = 0.0;
  final _arcAnimationEndValue = 1.0;
  final _rotationAnimationStartValue = 0.0;
  final _rotationAnimationEndValue = 1.0;
  final _scaleAnimationStartValue = 0.0;
  final _scaleAnimationEndValue = 1.0;

  AnimationController _arcAnimationController;
  AnimationController _rotationAnimationController;
  AnimationController _scaleAnimationController;

  Animation<double> _arcAnimation;
  Animation<double> _rotationAnimation;
  Animation<double> _scaleAnimation;

  double _arcProgress;
  double _rotation;
  double _scale;

  int _currentColorIndex;
  Color _currentColor;

  @override
  void initState() {
    super.initState();

    _scale = 0.0;
    _rotation = 0.0;
    _arcProgress = 0.0;
    _currentColorIndex = 0;
    _currentColor = _loadingColors[_currentColorIndex];

    // Arc animation
    _arcAnimationController = new AnimationController(vsync: this, duration: _arcAnimationDuration);
    var curveAnimation = CurvedAnimation(parent: _arcAnimationController, curve: Curves.easeInOutCubic);
    _arcAnimation = Tween(begin: _arcAnimationStartValue, end: _arcAnimationEndValue).animate(curveAnimation)
      ..addListener(() {
        setState(() {
          _arcProgress = _arcAnimation.value;
        });
      });
    _arcAnimationController.addStatusListener((status) {
      //print("arc animation status: $status");
      if (status == AnimationStatus.completed) {
        // Switch current color
        _currentColorIndex = _currentColorIndex + 1 >= _loadingColors.length ? 0 : _currentColorIndex + 1;
        _currentColor = _loadingColors[_currentColorIndex];

        // Repeat the animation
        _arcAnimationController.forward(from: _arcAnimationStartValue);
      }
    });

    // Rotation animation
    _rotationAnimationController = new AnimationController(vsync: this, duration: _rotationAnimationDuration);
    _rotationAnimation = Tween(begin: _rotationAnimationStartValue, end: _rotationAnimationEndValue).animate(_rotationAnimationController)
      ..addListener(() {
        setState(() {
          _rotation = _rotationAnimation.value;
        });
      });
    _rotationAnimationController.addStatusListener((status) {
      //print("rotation animation status: $status");
      if (status == AnimationStatus.completed) {
        // Repeat the animation
        _rotationAnimationController.forward(from: _rotationAnimationStartValue);
      }
    });

    // Scale Animation
    _scaleAnimationController = new AnimationController(vsync: this, duration: _scaleAnimationDuration);
    _scaleAnimation = Tween(begin: _scaleAnimationStartValue, end: _scaleAnimationEndValue).animate(_scaleAnimationController)
      ..addListener(() {
        setState(() {
          _scale = _scaleAnimation.value;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RainbowLoading(_scale, _rotation, _arcProgress, _currentColor)
    );
  }

  @override
  void dispose() {
    super.dispose();

    _scaleAnimationController.dispose();
    _rotationAnimationController.dispose();
    _arcAnimationController.dispose();
  }

  void start() {
    _scaleAnimationController.forward(from: _arcAnimationStartValue);
    _arcAnimationController.forward(from: _arcAnimationStartValue);
    _rotationAnimationController.forward(from: _rotationAnimationStartValue);
  }

  void stop() {
    _scaleAnimationController.reverse(from: _scale).then((val) {
      _scaleAnimationController.stop(canceled: false);
      _arcAnimationController.stop(canceled: false);
      _rotationAnimationController.stop(canceled: false);
    });
  }
}
