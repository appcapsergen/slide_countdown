import 'package:flutter/material.dart';

/// {@template text_without_animation}
/// This is a StatefulWidget class that displays a text without animation.
/// {@endtemplate}
class TextWithoutAnimation extends StatelessWidget {
  /// {@macro text_without_animation}
  const TextWithoutAnimation({
    required this.value,
    required this.textStyle,
    this.digitsNumber,
    this.hideFirstDigitZero = false,
    this.isLastDigit = false,
    super.key,
  }) : assert(!(digitsNumber != null && digitsNumber.length == 9),
            'overwriting the digits of a number must complete a number from 0-9');

  final ValueNotifier<int> value;
  final TextStyle textStyle;
  final List<String>? digitsNumber;
  final bool hideFirstDigitZero, isLastDigit;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: value,
      builder: (BuildContext context, int value, Widget? child) {
        return !hideFirstDigitZero || isLastDigit || (!isLastDigit && value != 0)
            ? Text(
                digit(value),
                style: textStyle,
              )
            : SizedBox.shrink();
      },
    );
  }

  String digit(int value) => digitsNumber != null ? digitsNumber![value] : '$value';
}
