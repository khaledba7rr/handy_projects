import 'package:flutter/material.dart';

import 'rps-custom.dart';

class TestScreen extends StatelessWidget {
  static const routeName = '/test';
  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context);
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
              left: 0,
              child: Container(
                width: deviceInfo.size.width,
                height: 80,
                child: Stack(
                  clipBehavior: Clip.antiAlias,
                  children: [
                    CustomPaint(
                      size: Size(deviceInfo.size.width,80),
                      painter: RPSCustomPainter(),
                    ),
                    Container(
                      width: deviceInfo.size.width,
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(onPressed: (){}, icon: Icon(Icons.text_snippet_rounded)),
                          IconButton(onPressed: (){}, icon: Icon(Icons.text_snippet_rounded)),
                          IconButton(onPressed: (){}, icon: Icon(Icons.text_snippet_rounded)),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
