import 'package:flutter/material.dart';

class RPSCustomPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    Paint paint_0 = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;


    Path path_0 = Path();
    path_0.moveTo(size.width*-0.0025000,size.height*0.3233333);
    path_0.quadraticBezierTo(size.width*0.2318750,size.height*0.2433333,size.width*0.3100000,size.height*0.2166667);
    path_0.cubicTo(size.width*0.3718750,size.height*0.2033333,size.width*0.3718750,size.height*0.2700000,size.width*0.3725000,size.height*0.3233333);
    path_0.cubicTo(size.width*0.3737500,size.height*0.9400000,size.width*0.6225000,size.height*0.9433333,size.width*0.6225000,size.height*0.3233333);
    path_0.cubicTo(size.width*0.6231250,size.height*0.2500000,size.width*0.6231250,size.height*0.2000000,size.width*0.6850000,size.height*0.2166667);
    path_0.quadraticBezierTo(size.width*0.7631250,size.height*0.2433333,size.width*0.9975000,size.height*0.3233333);
    path_0.lineTo(size.width*0.9975000,size.height*0.9933333);
    path_0.lineTo(size.width*-0.0025000,size.height*0.9933333);
    path_0.lineTo(size.width*-0.0025000,size.height*0.3233333);
    path_0.close();

    canvas.drawPath(path_0, paint_0);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}






