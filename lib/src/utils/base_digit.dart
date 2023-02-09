import 'dart:ui';

import 'package:flutter/material.dart';

import 'enum.dart';

abstract class BaseDigits extends StatelessWidget {
  const BaseDigits({
    required this.firstDigit,
    required this.secondDigit,
    required this.textStyle,
    required this.separatorStyle,
    required this.digitTitleStyle,
    required this.slideDirection,
    required this.curve,
    required this.countUp,
    required this.slideAnimationDuration,
    required this.separator,
    required this.hideFirstDigitZero,
    required this.showSeparator,
    required this.textDirection,
    this.digitTitle,
    this.separatorPadding,
    this.digitTitlePadding,
    this.digitsNumber,
    this.filter,
    super.key,
  });

  final ValueNotifier<int> firstDigit;
  final ValueNotifier<int> secondDigit;
  final TextStyle textStyle;
  final TextStyle separatorStyle;
  final TextStyle digitTitleStyle;
  final SlideDirection slideDirection;
  final Curve curve;
  final bool countUp;
  final Duration slideAnimationDuration;
  final String separator;
  final bool hideFirstDigitZero, showSeparator;
  final String? digitTitle;
  final TextDirection textDirection;
  final EdgeInsets? separatorPadding;
  final EdgeInsets? digitTitlePadding;
  final List<String>? digitsNumber;
  final ImageFilter? filter;
}
