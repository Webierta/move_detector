import 'package:flutter/material.dart';

class Grafico extends CustomPainter {
  double valorX;
  double valorY;
  double valorZ;

  Grafico({this.valorX = 0.0, this.valorY = 0.0, this.valorZ = 0.0});
  //Grafico({this.valorX, this.valorY, this.valorZ});

  @override
  void paint(Canvas canvas, Size size) {
    var alto = size.height * 5;

    var rectangulo = Paint()
      ..color = Colors.grey[200]
      ..style = PaintingStyle.fill;
    canvas.drawRect(
        Rect.fromLTRB(0, alto, size.width, size.height), rectangulo);
    /* canvas.drawRRect(
        RRect.fromLTRBAndCorners(0, alto, size.width, size.height,
            topLeft: Radius.circular(15.0)),
        rectangulo); */
    var eje = Paint()
      ..color = Colors.black26
      ..strokeWidth = 0.5;
    canvas.drawLine(
      Offset(0, alto / 1.75),
      Offset(size.width, alto / 1.75),
      eje,
    );
    canvas.drawLine(
      Offset(size.width / 2, size.height),
      Offset(size.width / 2, alto),
      eje,
    );

    var lineX = Paint()
      ..strokeWidth = 4
      ..color = Colors.deepOrange;
    var moveX = (size.width / 2) + valorX * 20;
    if (moveX < 0) moveX = 0.0;
    if (moveX > size.width) moveX = size.width;
    canvas.drawLine(
      Offset(moveX, size.height),
      Offset(moveX, alto),
      lineX,
    );

    var lineY = Paint()
      ..strokeWidth = 4
      ..color = Colors.deepPurple;
    var moveY = (size.width / 2) + valorY * 20;
    if (moveY < 0) moveY = 0.0;
    if (moveY > size.width) moveY = size.width;
    canvas.drawLine(
      Offset(moveY, size.height),
      Offset(moveY, alto),
      lineY,
    );

    var lineZ = Paint()
      ..strokeWidth = 4
      ..color = Colors.green[600];
    var moveZ = (size.width / 2) + valorZ * 20;
    if (moveZ < 0) moveZ = 0.0;
    if (moveZ > size.width) moveZ = size.width;
    canvas.drawLine(
      Offset(moveZ, size.height),
      Offset(moveZ, alto),
      lineZ,
    );
  }

  @override
  bool shouldRepaint(Grafico oldDelegate) {
    return true;
  }
}