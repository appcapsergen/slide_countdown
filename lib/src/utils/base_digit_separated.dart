import 'dart:ui';

import 'package:flutter/material.dart';

import 'enum.dart';
import 'utils.dart';

/// {@template base_digits_separated}
/// `BaseDigitsSeparated` is an abstract class that provides
/// the basic structure for building a widget that displays
/// two digits separated by a separator, with the ability to
/// animate the transition between values.
/// {@endtemplate}
abstract class BaseDigitsSeparated extends StatelessWidget {
  /// {@macro base_digits_separated}
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
    required this.textDirection,
    this.digitTitle,
    this.separatorPadding,
    this.digitTitlePadding,
    this.digitsNumber,
    this.filter,
    super.key,
  });

  /// The height of the widget.
  final double height;

  /// The width of the separated widget.
  final double width;

  /// The decoration to apply to the widget.
  final Decoration decoration;

  /// A ValueNotifier that holds the value of the first digit.
  final ValueNotifier<int> firstDigit;

  /// A ValueNotifier that holds the value of the second digit.
  final ValueNotifier<int> secondDigit;

  /// The style for the text of the digits.
  final TextStyle textStyle;

  /// The style for the separator.
  final TextStyle separatorStyle;

  /// The style for the digit title
  final TextStyle digitTitleStyle;

  /// The initial value for the widget.
  final int initValue;

  /// The direction in which the digits should slide during the animation.
  final SlideDirection slideDirection;

  /// Whether or not to display a zero value.
  final bool showZeroValue;

  ///  The curve to use for the animation.
  final Curve curve;

  /// Whether to animate the digits counting up or down.
  final bool countUp;

  /// The duration of the animation.
  final Duration slideAnimationDuration;

  /// The string to use as the separator.
  final String separator;

  /// Whether the first digit should be hidden. (For example when there's 7 hours, whether it should show "7" or "07")
  final bool hideFirstDigitZero;

  /// Whether or not to display the separator.
  final bool showSeparator;

  /// The direction in which the text should flow.
  final TextDirection textDirection;

  /// The title for a digit. (For example days, hours, etc.)
  final String? digitTitle;

  /// Padding to add around the separator.
  final EdgeInsets? separatorPadding;

  /// Padding to add around the digit title
  final EdgeInsets? digitTitlePadding;

  /// {@macro override_digits}
  final OverrideDigits? digitsNumber;

  /// Image filter for the digit box background
  final ImageFilter? filter;
}
