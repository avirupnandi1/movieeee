import 'package:flutter/material.dart';

class Cardclipper extends CustomClipper<Path> {
  double cornerRadius;
  Cardclipper({required this.cornerRadius});
  @override
  Path getClip(Size size) {
    var path = Path();

    double topClipPoint = size.width * 0.5;
    double bottomClipPoint = 2 * cornerRadius;

    path
      // reaching top clipPoint
      ..moveTo(topClipPoint + cornerRadius, 0)
      // drawing top curves
      ..quadraticBezierTo(topClipPoint, 0, topClipPoint, cornerRadius)
      ..quadraticBezierTo(topClipPoint, 2 * cornerRadius,
          topClipPoint - cornerRadius, 2 * cornerRadius)
      ..lineTo(cornerRadius, 2 * cornerRadius)
      ..quadraticBezierTo(0, 2 * cornerRadius, 0, 3 * cornerRadius)
      ..lineTo(0, cornerRadius)
      ..lineTo(0, size.height - cornerRadius)
      //BottomLeft
      ..quadraticBezierTo(0, size.height, cornerRadius, size.height)
      ..lineTo(size.width - bottomClipPoint - cornerRadius, size.height)
      // drawing bottom curves
      ..quadraticBezierTo(size.width - bottomClipPoint, size.height,
          size.width - bottomClipPoint, size.height - cornerRadius)
      ..quadraticBezierTo(
          size.width - bottomClipPoint,
          size.height - 2 * cornerRadius,
          size.width - bottomClipPoint + cornerRadius,
          size.height - 2 * cornerRadius)
      ..quadraticBezierTo(size.width, size.height - 2 * cornerRadius,
          size.width, size.height - 3 * cornerRadius)
      ..lineTo(size.width, cornerRadius)
      ..quadraticBezierTo(size.width, 0, size.width - cornerRadius, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}