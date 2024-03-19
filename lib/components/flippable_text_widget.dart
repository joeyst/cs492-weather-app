
import 'package:flutter/material.dart';
import './flipped_text_widget.dart';
import 'package:rotation/rotation.dart';

class FlippableTextWidget extends StatelessWidget {
  final String text;
  const FlippableTextWidget(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return RotatorFlip(
      firstChild: Text(text),
      secondChild: FlippedTextWidget(text),
      duration: const Duration(seconds: 1),
    );
  }
}