



import 'dart:math';

import 'package:flutter/material.dart';

class SectionHeadingWidget extends StatelessWidget {
  final String title;
  const SectionHeadingWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    double minWidth = min(MediaQuery.of(context).size.width - 128, 160);
    return Row(
      children: [
        const SizedBox(
          width: 24,
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 16,
        ),
        Container(
          color: Colors.white,
          child: CustomPaint(
              foregroundPainter: FadingEffect(),
              //child gets the fading effect
              child:
                  Container(height: 1, width: minWidth, color: Colors.black54)),
        ),
      ],
    );
  }
}

class FadingEffect extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Rect rect =
        Rect.fromPoints(const Offset(0, 0), Offset(size.width, size.height));
    LinearGradient lg = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          //create 2 white colors, one transparent
          Color.fromARGB(0, 255, 255, 255),
          Color.fromARGB(255, 211, 205, 205)
        ]);
    Paint paint = Paint()..shader = lg.createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(FadingEffect oldDelegate) => false;
}