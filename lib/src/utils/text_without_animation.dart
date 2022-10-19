import 'package:flutter/material.dart';

class TextWithoutAnimation extends StatelessWidget {
  const TextWithoutAnimation({
    required this.value,
    required this.textStyle,
    this.digitsNumber,
    this.hideFirstDigitZero = false,
    this.isLastDigit = false,
    super.key,
  });

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
