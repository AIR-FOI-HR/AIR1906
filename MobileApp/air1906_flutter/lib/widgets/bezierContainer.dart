import './ClipPainter.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/painting.dart';
class BezierContainer extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Transform.rotate(
        angle: -pi / 3.5, 
        child: ClipPath(
        clipper: ClipPainter(),
        child: Container(
          height: MediaQuery.of(context).size.height *.5,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xfffbb448),Color(0xffe46b10)]
              )
            ),
        ),
      ),
      )
    );
  }
}