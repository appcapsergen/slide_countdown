import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:slide_countdown/src/utils/utils.dart';

import '../slide_countdown.dart';
import 'separated/separated.dart';
import 'utils/countdown_mixin.dart';
import 'utils/extensions.dart';
import 'utils/notify_duration.dart';
import 'utils/text_animation.dart';

/// {@template slide_countdown_separated}
/// The SlideCountdownSeparated is a StatefulWidget that
/// creates a countdown timer that slides up or down to display
/// the remaining time and each duration will be separated.
///
/// Example usage:
///
/// ```dart
/// SlideCountdownSeparated(
///   duration: const Duration(days: 2),
/// );
/// ```
/// {@endtemplate}
class SlideCountdownSeparated extends StatefulWidget {
  /// {@macro slide_countdown_separated}
  const SlideCountdownSeparated({
    this.duration,
    this.height = 30.0,
    this.width = 30.0,
    this.textStyle = const TextStyle(
      color: Color(0xFFFFFFFF),
      fontWeight: FontWeight.bold,
    ),
    this.separatorStyle = const TextStyle(
      color: Color(0xFF000000),
      fontWeight: FontWeight.bold,
    ),
    this.digitTitleStyle = const TextStyle(
      color: Color(0xFF000000),
      fontWeight: FontWeight.bold,
    ),
    this.icon,
    this.suffixIcon,
    this.separator,
    this.replacement,
    this.onDone,
    this.durationTitle,
    this.separatorType = SeparatorType.symbol,
    this.slideDirection = SlideDirection.down,
    this.padding = const EdgeInsets.all(5.0),
    this.separatorPadding = const EdgeInsets.symmetric(horizontal: 3.0),
    this.digitTitlePadding = const EdgeInsets.symmetric(horizontal: 3.0),
    this.showZeroValue = false,
    this.hideFirstDigitZero = false,
    this.showSeparator = true,
    this.showDigitTitles = false,
    this.decoration = const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      color: Color(0xFFF23333),
    ),
    this.curve = Curves.easeOut,
    this.countUp = false,
    this.infinityCountUp = false,
    this.slideAnimationDuration = const Duration(milliseconds: 300),
    this.textDirection = TextDirection.ltr,
    this.digitsNumber,
    this.filter,
    this.streamDuration,
    this.onChanged,
    this.shouldShowDays,
    this.shouldShowHours,
    this.shouldShowMinutes,
    this.shouldShowSeconds,
    super.key,
  }) : assert(
          duration != null || streamDuration != null,
          'Either duration or streamDuration has to be provided',
        );

  /// [Duration] is the duration of the countdown slide,
  /// if the duration has finished it will call [onDone]
  final Duration? duration;

  /// height to set the size of height each [Container]
  /// [Container] will be the background of each a duration
  /// to decorate the [Container] on the [decoration] property
  final double height;

  /// width to set the size of width each [Container]
  /// [Container] will be the background of each a duration
  /// to decorate the [Container] on the [decoration] property
  final double width;

  /// [TextStyle] is a parameter for all existing text,
  /// if this is null [SlideCountdownSeparated] has a default
  /// text style which will be of all text
  final TextStyle textStyle;

  /// [TextStyle] is a parameter for all existing text,
  /// if this is null [SlideCountdownSeparated] has a default
  /// text style which will be of all text
  final TextStyle separatorStyle;

  /// [TextStyle] is a parameter for all existing text,
  /// if this is null [SlideCountdownSeparated] has a default
  /// text style which will be of all text
  final TextStyle digitTitleStyle;

  /// [icon] is a parameter that can be initialized by any widget e.g [Icon],
  /// this will be in the first order, default empty widget
  final Widget? icon;

  /// [icon] is a parameter that can be initialized by any widget e.g [Icon],
  /// this will be in the end order, default empty widget
  final Widget? suffixIcon;

  /// Separator is a parameter that will separate each [duration],
  /// e.g hours by minutes, and you can change the [SeparatorType] of the symbol or title
  final String? separator;

  /// A widget that will be displayed to replace
  /// the countdown when the remaining [duration] has finished
  /// if null  default widget is [SizedBox].
  final Widget? replacement;

  /// function [onDone] will be called when countdown is complete
  final VoidCallback? onDone;

  /// {$macro separator_type}
  final SeparatorType separatorType;

  /// change [Duration Title] if you want to change the default language,
  /// which is English, to another language, for example, into Indonesian
  /// pro tips: if you change to Indonesian, we have default values [DurationTitle.id()]
  final DurationTitle? durationTitle;

  /// The decoration to paint in front of the [child].
  final Decoration decoration;

  /// The amount of space by which to inset the child.
  final EdgeInsets padding;

  /// The amount of space by which to inset the [separator].
  final EdgeInsets separatorPadding;

  /// The amount of space by which to inset the digit titles.
  final EdgeInsets digitTitlePadding;

  /// if you initialize it with false, the duration which is empty will not be displayed
  final bool showZeroValue;

  /// if you want to hide the first digit when it's 0 (zero) set this value to true
  final bool hideFirstDigitZero;

  /// if you want the [separator] to be visible set this value to true
  final bool showSeparator;

  /// if you want the digit titles to be visible under the digits set this value to true
  final bool showDigitTitles;

  /// {@macro slide_direction}
  final SlideDirection slideDirection;

  /// to customize curve in [TextAnimation] you can change the default value
  /// default [Curves.easeOut]
  final Curve curve;

  ///this property allows you to do a count up, give it a value of true to do it
  final bool countUp;

  /// if you set this property value to true, it will do the count up continuously or infinity
  /// and the [onDone] property will never be executed,
  /// before doing that you need to set true to the [countUp] property,
  final bool infinityCountUp;

  /// SlideAnimationDuration which will be the duration of the slide animation from above or below
  final Duration slideAnimationDuration;

  /// Text direction for change row positions of each item
  /// ltr => [01] : [02] : [03]
  /// rtl => [03] : [02] : [01]
  final TextDirection textDirection;

  /// {@macro override_digits}
  final OverrideDigits? digitsNumber;

  /// ImageFilter for optional backdrop filter
  final ImageFilter? filter;

  /// If you override [StreamDuration] package for stream a duration
  /// property [duration], [countUp], [infinityCountUp], and [onDone] in [SlideCountdownSeparated] not affected
  /// Example you need use function in [StreamDuration]
  /// e.g correct, add, and subtract function
  final StreamDuration? streamDuration;

  /// if you need to stream the remaining available duration,
  /// it will be called every time the duration changes.
  final ValueChanged<Duration>? onChanged;

  /// This will trigger the days item will show or hide from the return value
  /// You can also show or hide based on the remaining duration
  /// e.g shouldShowDays: (`Duration` remainingDuration) => remainingDuration.inDays >= 1
  /// if null and [showZeroValue] is false
  /// when duration in days is zero it will return false
  final ShouldShowItems? shouldShowDays;

  /// This will trigger the hours item will show or hide from the return value
  /// You can also show or hide based on the remaining duration
  /// e.g shouldShowHours: () => remainingDuration.inHours >= 1
  /// if null and [showZeroValue] is false
  /// when duration in hours is zero it will return false
  final ShouldShowItems? shouldShowHours;

  /// This will trigger the minutes item will show or hide from the return value
  /// You can also show or hide based on the remaining duration
  /// e.g shouldShowMinutes: () => remainingDuration.inMinutes >= 1
  /// if null and [showZeroValue] is false
  /// when duration in minutes is zero it will return false
  final ShouldShowItems? shouldShowMinutes;

  /// This will trigger the minutes item will show or hide from the return value
  /// You can also show or hide based on the remaining duration
  /// e.g shouldShowSeconds: () => remainingDuration.inSeconds >= 1
  /// if null and [showZeroValue] is false
  /// when duration in seconds is zero it will return false
  final ShouldShowItems? shouldShowSeconds;

  @override
  _SlideCountdownSeparatedState createState() => _SlideCountdownSeparatedState();
}

class _SlideCountdownSeparatedState extends State<SlideCountdownSeparated> with CountdownMixin {
  late StreamDuration _streamDuration;
  late NotifyDuration _notifyDuration;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _notifyDuration = NotifyDuration(duration);
    _disposed = false;
    _streamDurationListener();
    _updateConfigurationNotifier(widget.duration);
  }

  @override
  void didUpdateWidget(covariant SlideCountdownSeparated oldWidget) {
    if (widget.countUp != oldWidget.countUp || widget.infinityCountUp != oldWidget.infinityCountUp) {
      _streamDurationListener();
    }
    if (widget.duration != oldWidget.duration && widget.duration != null) {
      _streamDuration.change(widget.duration!);
    }

    if (oldWidget.shouldShowDays != widget.shouldShowDays ||
        oldWidget.shouldShowHours != widget.shouldShowHours ||
        oldWidget.shouldShowMinutes != widget.shouldShowMinutes ||
        oldWidget.shouldShowSeconds != widget.shouldShowSeconds ||
        oldWidget.showZeroValue != widget.showZeroValue) {
      _updateConfigurationNotifier();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _streamDurationListener() {
    _streamDuration = StreamDuration(
      duration,
      onDone: () {
        if (widget.onDone != null) {
          widget.onDone!();
        }
      },
      countUp: widget.countUp,
      infinity: widget.infinityCountUp,
    );

    if (!_disposed) {
      try {
        _streamDuration.durationLeft.listen((duration) {
          _notifyDuration.streamDuration(duration);
          updateValue(duration);
          if (widget.onChanged != null) {
            widget.onChanged!(duration);
          }
        });
      } catch (ex) {
        debugPrint(ex.toString());
      }
    }
  }

  void _updateConfigurationNotifier([Duration? duration]) {
    final remainingDuration = duration ?? _streamDuration.remainingDuration;
    final defaultShowDays = remainingDuration.inDays < 1 && !widget.showZeroValue ? false : true;
    final defaultShowHours = remainingDuration.inHours < 1 && !widget.showZeroValue ? false : true;
    final defaultShowMinutes = remainingDuration.inMinutes < 1 && !widget.showZeroValue ? false : true;
    final defaultShowSeconds = remainingDuration.inSeconds < 1 && !widget.showZeroValue ? false : true;

    /// cal func from CountdownMixin
    updateConfigurationNotifier(
      updateDaysNotifier: widget.shouldShowDays != null ? widget.shouldShowDays!(remainingDuration) : defaultShowDays,
      updateHoursNotifier:
          widget.shouldShowHours != null ? widget.shouldShowHours!(remainingDuration) : defaultShowHours,
      updateMinutesNotifier:
          widget.shouldShowMinutes != null ? widget.shouldShowMinutes!(remainingDuration) : defaultShowMinutes,
      updateSecondsNotifier:
          widget.shouldShowSeconds != null ? widget.shouldShowSeconds!(remainingDuration) : defaultShowSeconds,
    );
  }

  Duration get duration => widget.duration ?? widget.streamDuration!.duration;

  @override
  void dispose() {
    super.dispose();
    _disposed = true;
    _streamDuration.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final durationTitle = widget.durationTitle ?? DurationTitle.en();
    final separator = widget.separator ?? ':';

    final leadingIcon = Visibility(
      visible: widget.icon != null,
      child: widget.icon ?? const SizedBox.shrink(),
    );

    final suffixIcon = Visibility(
      visible: widget.suffixIcon != null,
      child: widget.suffixIcon ?? const SizedBox.shrink(),
    );

    final int daysDigitAmount = duration.inDays.toString().length;
    final TextStyle daysTextStyle = widget.textStyle.merge(TextStyle(
      fontSize: (widget.textStyle.fontSize ?? 15.0) / (daysDigitAmount > 2 ? (pow(1.05, daysDigitAmount - 2)) : 1.0),
    ));

    final days = DigitSeparatedItem(
      height: widget.height,
      width: widget.width,
      decoration: widget.decoration,
      firstDigit: daysFirstDigitNotifier,
      secondDigit: daysSecondDigitNotifier,
      textStyle: daysTextStyle,
      separatorStyle: widget.separatorStyle,
      digitTitleStyle: widget.digitTitleStyle,
      initValue: 0,
      slideDirection: widget.slideDirection,
      showZeroValue: widget.showZeroValue,
      curve: widget.curve,
      countUp: widget.countUp,
      slideAnimationDuration: widget.slideAnimationDuration,
      hideFirstDigitZero: widget.hideFirstDigitZero,
      showSeparator: widget.showSeparator,
      // showSeparator: (showHours || showMinutes || showSeconds) || (isSeparatorTitle && showDays),
      digitTitle: widget.showDigitTitles ? durationTitle.days : null,
      separatorPadding: widget.separatorPadding,
      digitTitlePadding: widget.digitTitlePadding,
      separator: widget.separatorType == SeparatorType.title ? durationTitle.days : separator,
      textDirection: widget.textDirection,
      digitsNumber: widget.digitsNumber,
      filter: widget.filter,
    );

    final hours = DigitSeparatedItem(
      height: widget.height,
      width: widget.width,
      decoration: widget.decoration,
      firstDigit: hoursFirstDigitNotifier,
      secondDigit: hoursSecondDigitNotifier,
      textStyle: widget.textStyle,
      separatorStyle: widget.separatorStyle,
      digitTitleStyle: widget.digitTitleStyle,
      initValue: 0,
      slideDirection: widget.slideDirection,
      showZeroValue: widget.showZeroValue,
      curve: widget.curve,
      countUp: widget.countUp,
      slideAnimationDuration: widget.slideAnimationDuration,
      hideFirstDigitZero: widget.hideFirstDigitZero,
      showSeparator: widget.showSeparator,
      // showSeparator: showMinutes || showSeconds || (isSeparatorTitle && showHours),
      digitTitle: widget.showDigitTitles ? durationTitle.hours : null,
      separatorPadding: widget.separatorPadding,
      digitTitlePadding: widget.digitTitlePadding,
      separator: widget.separatorType == SeparatorType.title ? durationTitle.hours : separator,
      textDirection: widget.textDirection,
      digitsNumber: widget.digitsNumber,
      filter: widget.filter,
    );

    final minutes = DigitSeparatedItem(
      height: widget.height,
      width: widget.width,
      decoration: widget.decoration,
      firstDigit: minutesFirstDigitNotifier,
      secondDigit: minutesSecondDigitNotifier,
      textStyle: widget.textStyle,
      separatorStyle: widget.separatorStyle,
      digitTitleStyle: widget.digitTitleStyle,
      initValue: 0,
      slideDirection: widget.slideDirection,
      showZeroValue: widget.showZeroValue,
      curve: widget.curve,
      countUp: widget.countUp,
      slideAnimationDuration: widget.slideAnimationDuration,
      hideFirstDigitZero: widget.hideFirstDigitZero,
      showSeparator: widget.showSeparator,
      // showSeparator: showSeconds || (isSeparatorTitle && showMinutes),
      digitTitle: widget.showDigitTitles ? durationTitle.minutes : null,
      separatorPadding: widget.separatorPadding,
      digitTitlePadding: widget.digitTitlePadding,
      separator: widget.separatorType == SeparatorType.title ? durationTitle.minutes : separator,
      textDirection: widget.textDirection,
      digitsNumber: widget.digitsNumber,
      filter: widget.filter,
    );

    final seconds = DigitSeparatedItem(
      height: widget.height,
      width: widget.width,
      decoration: widget.decoration,
      firstDigit: secondsFirstDigitNotifier,
      secondDigit: secondsSecondDigitNotifier,
      textStyle: widget.textStyle,
      separatorStyle: widget.separatorStyle,
      digitTitleStyle: widget.digitTitleStyle,
      initValue: 0,
      slideDirection: widget.slideDirection,
      showZeroValue: widget.showZeroValue,
      curve: widget.curve,
      countUp: widget.countUp,
      slideAnimationDuration: widget.slideAnimationDuration,
      hideFirstDigitZero: widget.hideFirstDigitZero,
      showSeparator: widget.showSeparator && widget.separatorType == SeparatorType.title,
      // showSeparator: isSeparatorTitle && showSeconds,
      digitTitle: widget.showDigitTitles ? durationTitle.seconds : null,
      separatorPadding: widget.separatorPadding,
      digitTitlePadding: widget.digitTitlePadding,
      separator: widget.separatorType == SeparatorType.title ? durationTitle.seconds : separator,
      textDirection: widget.textDirection,
      digitsNumber: widget.digitsNumber,
      filter: widget.filter,
    );

    return ValueListenableBuilder(
      valueListenable: _notifyDuration,
      builder: (_, Duration duration, __) {
        final daysWidget = showWidget(duration.inDays, widget.showZeroValue) ? days : const SizedBox.shrink();
        final hoursWidget = showWidget(duration.inHours, widget.showZeroValue) ? hours : const SizedBox.shrink();
        final minutesWidget = showWidget(duration.inMinutes, widget.showZeroValue) ? minutes : const SizedBox.shrink();
        final secondsWidget = showWidget(duration.inSeconds, widget.showZeroValue) ? seconds : const SizedBox.shrink();

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: widget.textDirection.isRtl
              ? [
                  suffixIcon,
                  secondsWidget,
                  minutesWidget,
                  hoursWidget,
                  daysWidget,
                  leadingIcon,
                ]
              : [
                  leadingIcon,
                  daysWidget,
                  hoursWidget,
                  minutesWidget,
                  secondsWidget,
                  suffixIcon,
                ],
        );
      },
      child: widget.replacement,
    );
  }
}
