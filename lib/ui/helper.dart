import 'dart:ui';

import 'package:flutter/material.dart';

class BlurryBackground extends StatelessWidget {
  Widget build(BuildContext content) {
    return Stack(
      children: [
        Align(
          alignment: AlignmentDirectional(3, -.3),
          child: Container(
            height: 350,
            width: 350,
            decoration:
                BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle),
          ),
        ),
        Align(
          alignment: AlignmentDirectional(-3, -.3),
          child: Container(
            height: 350,
            width: 350,
            decoration:
                BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle),
          ),
        ),
        Align(
          alignment: AlignmentDirectional(0, -1.2),
          child: Container(
            height: 350,
            width: 400,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 221, 115, 9),
            ),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
          child: Container(
            decoration: BoxDecoration(color: Colors.transparent),
          ),
        ),
      ],
    );
  }
}

class small_widget extends StatelessWidget {
  final String imgPath;
  final String top;
  final String bottom;

  const small_widget({
    super.key,
    required this.imgPath,
    required this.top,
    required this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          imgPath,
          width: 60,
          height: 60,
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${top}',
              style: TextStyle(color: Colors.white24, fontSize: 15),
            ),
            Text(
              '${bottom}',
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
          ],
        )
      ],
    );
  }
}
