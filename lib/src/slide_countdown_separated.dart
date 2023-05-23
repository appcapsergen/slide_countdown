import 'dart:math';

import 'package:flutter/material.dart';
import 'package:slide_countdown/src/utils/slide_countdown_base.dart';
import 'package:slide_countdown/src/utils/utils.dart';

import '../slide_countdown.dart';
import 'separated/separated.dart';
import 'utils/countdown_mixin.dart';
import 'utils/extensions.dart';
import 'utils/notify_duration.dart';

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
class SlideCountdownSeparated extends SlideCountdownBase {
  /// {@macro slide_countdown_separated}
  const SlideCountdownSeparated({
    super.key,
    super.duration,
    this.height = 30.0,
    this.width = 30.0,
    this.showSeparator,
    super.textStyle = kDefaultTextStyle,
    super.separatorStyle = kDefaultSeparatorTextStyle,
    super.digitTitleStyle = kDefaultDigitTitleTextStyle,
    super.icon,
    super.suffixIcon,
    super.separator,
    super.replacement,
    super.onDone,
    super.durationTitle,
    super.separatorType = SeparatorType.symbol,
    super.slideDirection = SlideDirection.down,
    super.padding = const EdgeInsets.all(5.0),
    super.separatorPadding = const EdgeInsets.symmetric(horizontal: 3.0),
    super.digitTitlePadding = const EdgeInsets.symmetric(horizontal: 3.0),
    super.showZeroValue = false,
    super.hideFirstDigitZero = false,
    super.showDigitTitles = false,
    super.decoration = kDefaultSeparatedBoxDecoration,
    super.curve = Curves.easeOut,
    super.countUp = false,
    super.infinityCountUp = false,
    super.countUpAtDuration,
    super.slideAnimationDuration = kDefaultAnimationDuration,
    super.digitsNumber,
    super.filter,
    super.streamDuration,
    super.onChanged,
    super.shouldShowDays,
    super.shouldShowHours,
    super.shouldShowMinutes,
    super.shouldShowSeconds,
  });

  /// height to set the size of height each [Container]
  /// [Container] will be the background of each a duration
  /// to decorate the [Container] on the [decoration] property
  final double height;

  /// width to set the size of width each [Container]
  /// [Container] will be the background of each a duration
  /// to decorate the [Container] on the [decoration] property
  final double width;

  /// if you want the [separator] to be visible set this value to true
  final bool? showSeparator;

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
      _streamDuration.dispose();
      _streamDurationListener();
    }
    if (widget.duration != oldWidget.duration) {
      _streamDuration.change(duration);
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
    _streamDuration = widget.streamDuration ??
        StreamDuration(
          duration,
          onDone: () => widget.onDone?.call(),
          countUp: widget.countUp,
          countUpAtDuration: widget.countUpAtDuration ?? false,
          infinity: widget.infinityCountUp,
        );

    if (!_disposed) {
      try {
        _streamDuration.durationLeft.listen(
          (duration) {
            _notifyDuration.streamDuration(duration);
            updateValue(duration);
            widget.onChanged?.call(duration);
          },
        );
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
    final textDirection = Directionality.of(context);

    final leadingIcon = Visibility(
      visible: widget.icon != null,
      child: widget.icon ?? const SizedBox.shrink(),
    );

    final suffixIcon = Visibility(
      visible: widget.suffixIcon != null,
      child: widget.suffixIcon ?? const SizedBox.shrink(),
    );

    return ValueListenableBuilder(
      valueListenable: _notifyDuration,
      builder: (BuildContext context, Duration duration, Widget? child) {
        if (duration.inSeconds <= 0 && child != null) return child;

        final defaultShowDays = duration.inDays < 1 && !widget.showZeroValue ? false : true;
        final defaultShowHours = duration.inHours < 1 && !widget.showZeroValue ? false : true;
        final defaultShowMinutes = duration.inMinutes < 1 && !widget.showZeroValue ? false : true;
        final defaultShowSeconds = duration.inSeconds < 1 && !widget.showZeroValue ? false : true;

        final showDays = widget.shouldShowDays != null ? widget.shouldShowDays!(duration) : defaultShowDays;
        final showHours = widget.shouldShowHours != null ? widget.shouldShowHours!(duration) : defaultShowHours;
        final showMinutes = widget.shouldShowMinutes != null ? widget.shouldShowMinutes!(duration) : defaultShowMinutes;
        final showSeconds = widget.shouldShowSeconds != null ? widget.shouldShowSeconds!(duration) : defaultShowSeconds;
        final isSeparatorTitle = widget.separatorType == SeparatorType.title;

        final int daysDigitAmount = duration.inDays.toString().length;
        final TextStyle daysTextStyle = widget.textStyle.merge(TextStyle(
          fontSize:
              (widget.textStyle.fontSize ?? 15.0) / (daysDigitAmount > 2 ? (pow(1.05, daysDigitAmount - 2)) : 1.0),
        ));

        final days = DigitSeparatedItem(
          height: widget.height,
          width: widget.width,
          showSeparator:
              widget.showSeparator ?? (showHours || showMinutes || showSeconds) || (isSeparatorTitle && showDays),
          decoration: widget.decoration,
          firstDigit: daysFirstDigitNotifier,
          secondDigit: daysSecondDigitNotifier,
          textStyle: daysTextStyle,
          separatorStyle: widget.separatorStyle,
          digitTitleStyle: widget.digitTitleStyle,
          initValue: 0,
          slideDirection: widget.slideDirection,
          showZeroValue: widget.showZeroValue,
          hideFirstDigitZero: widget.hideFirstDigitZero,
          curve: widget.curve,
          countUp: widget.countUp,
          slideAnimationDuration: widget.slideAnimationDuration,
          separatorPadding: widget.separatorPadding,
          digitTitlePadding: widget.digitTitlePadding,
          separator: widget.separatorType == SeparatorType.title ? durationTitle.days : separator,
          digitTitle: widget.showDigitTitles ? durationTitle.days : null,
          textDirection: textDirection,
          digitsNumber: widget.digitsNumber,
          filter: widget.filter,
        );

        final hours = DigitSeparatedItem(
          height: widget.height,
          width: widget.width,
          showSeparator: widget.showSeparator ?? (showMinutes || showSeconds) || (isSeparatorTitle && showHours),
          decoration: widget.decoration,
          firstDigit: hoursFirstDigitNotifier,
          secondDigit: hoursSecondDigitNotifier,
          textStyle: widget.textStyle,
          separatorStyle: widget.separatorStyle,
          digitTitleStyle: widget.digitTitleStyle,
          initValue: 0,
          slideDirection: widget.slideDirection,
          showZeroValue: widget.showZeroValue,
          hideFirstDigitZero: widget.hideFirstDigitZero,
          curve: widget.curve,
          countUp: widget.countUp,
          slideAnimationDuration: widget.slideAnimationDuration,
          separatorPadding: widget.separatorPadding,
          digitTitlePadding: widget.digitTitlePadding,
          separator: widget.separatorType == SeparatorType.title ? durationTitle.hours : separator,
          digitTitle: widget.showDigitTitles ? durationTitle.hours : null,
          textDirection: textDirection,
          digitsNumber: widget.digitsNumber,
          filter: widget.filter,
        );

        final minutes = DigitSeparatedItem(
          height: widget.height,
          width: widget.width,
          showSeparator: widget.showSeparator ?? showSeconds || (isSeparatorTitle && showMinutes),
          decoration: widget.decoration,
          firstDigit: minutesFirstDigitNotifier,
          secondDigit: minutesSecondDigitNotifier,
          textStyle: widget.textStyle,
          separatorStyle: widget.separatorStyle,
          digitTitleStyle: widget.digitTitleStyle,
          initValue: 0,
          slideDirection: widget.slideDirection,
          showZeroValue: widget.showZeroValue,
          hideFirstDigitZero: widget.hideFirstDigitZero,
          curve: widget.curve,
          countUp: widget.countUp,
          slideAnimationDuration: widget.slideAnimationDuration,
          separatorPadding: widget.separatorPadding,
          digitTitlePadding: widget.digitTitlePadding,
          separator: widget.separatorType == SeparatorType.title ? durationTitle.minutes : separator,
          digitTitle: widget.showDigitTitles ? durationTitle.minutes : null,
          textDirection: textDirection,
          digitsNumber: widget.digitsNumber,
          filter: widget.filter,
        );

        final seconds = DigitSeparatedItem(
          height: widget.height,
          width: widget.width,
          showSeparator: widget.showSeparator ?? isSeparatorTitle && showSeconds,
          decoration: widget.decoration,
          firstDigit: secondsFirstDigitNotifier,
          secondDigit: secondsSecondDigitNotifier,
          textStyle: widget.textStyle,
          separatorStyle: widget.separatorStyle,
          digitTitleStyle: widget.digitTitleStyle,
          initValue: 0,
          slideDirection: widget.slideDirection,
          showZeroValue: widget.showZeroValue,
          hideFirstDigitZero: widget.hideFirstDigitZero,
          curve: widget.curve,
          countUp: widget.countUp,
          slideAnimationDuration: widget.slideAnimationDuration,
          separatorPadding: widget.separatorPadding,
          digitTitlePadding: widget.digitTitlePadding,
          separator: widget.separatorType == SeparatorType.title ? durationTitle.seconds : separator,
          digitTitle: widget.showDigitTitles ? durationTitle.seconds : null,
          textDirection: textDirection,
          digitsNumber: widget.digitsNumber,
          filter: widget.filter,
        );

        final daysWidget = showWidget(duration.inDays, widget.showZeroValue) ? days : const SizedBox.shrink();
        final hoursWidget = showWidget(duration.inHours, widget.showZeroValue) ? hours : const SizedBox.shrink();
        final minutesWidget = showWidget(duration.inMinutes, widget.showZeroValue) ? minutes : const SizedBox.shrink();
        final secondsWidget = showWidget(duration.inSeconds, widget.showZeroValue) ? seconds : const SizedBox.shrink();

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: textDirection.isRtl
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
