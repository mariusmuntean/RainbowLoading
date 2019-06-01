import 'package:flutter/material.dart';

import 'CustomWidgets/RainbowLoadingWidget.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: AlignmentDirectional.center,
              child: SizedBox.fromSize(
                size: Size(100, 100),
                child: RainbowLoadingWidget(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
