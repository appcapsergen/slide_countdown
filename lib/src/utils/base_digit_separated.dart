import 'dart:ui';

import 'package:flutter/material.dart';

import 'enum.dart';

abstract class BaseDigitsSeparated extends StatelessWidget {
  const BaseDigitsSeparated({
    required this.height,
    required this.width,
    required this.decoration,
    required this.firstDigit,
    required this.secondDigit,
    required this.textStyle,
    required this.separatorStyle,
    required this.digitTitleStyle,
    required this.initValue,
    required this.slideDirection,
    required this.showZeroValue,
    required this.curve,
    required this.countUp,
    required this.slideAnimationDuration,
    required this.separator,
    required this.hideFirstDigitZero,
    required this.showSeparator,
    this.digitTitle,
    this.separatorPadding,
    this.digitTitlePadding,
    this.textDirection,
    this.digitsNumber,
    this.filter,
    super.key,
  });

  final double height;
  final double width;
  final Decoration decoration;
  final ValueNotifier<int> firstDigit;
  final ValueNotifier<int> secondDigit;
  final TextStyle textStyle;
  final TextStyle separatorStyle;
  final TextStyle digitTitleStyle;
  final int initValue;
  final SlideDirection slideDirection;
  final bool showZeroValue;
  final Curve curve;
  final bool countUp;
  final Duration slideAnimationDuration;
  final String separator;
  final bool hideFirstDigitZero, showSeparator;
  final String? digitTitle;
  final EdgeInsets? separatorPadding;
  final EdgeInsets? digitTitlePadding;
  final TextDirection? textDirection;
  final List<String>? digitsNumber;
  final ImageFilter? filter;
}
