// SOURCE: https://stackoverflow.com/questions/53350909/how-to-invert-a-text-in-flutter/53351454#53351454 

import 'package:flutter/material.dart';
import 'dart:math';
class FlippedText extends StatelessWidget {
  final String text;
  const FlippedText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Transform(
        transform:Matrix4.rotationX(pi),
        alignment: Alignment.center,

        child: Container(
          height: 100.0,
          color: Theme.of(context).colorScheme.primary,
          child: Center(child: Text(text, style: TextStyle(fontSize: 70.0, color: Theme.of(context).colorScheme.secondary)),),
        ),
      ),
    );
  }
}