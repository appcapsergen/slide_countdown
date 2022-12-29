import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:slide_countdown/src/utils/extensions.dart';
import 'package:stream_duration/stream_duration.dart';

import 'default/default.dart';
import 'utils/countdown_mixin.dart';
import 'utils/duration_title.dart';
import 'utils/enum.dart';
import 'utils/notify_duration.dart';
import 'utils/utils.dart';

class SlideCountdown extends StatefulWidget {
  const SlideCountdown({
    this.duration,
    this.textStyle = const TextStyle(
      color: Color(0xFFFFFFFF),
      fontWeight: FontWeight.bold,
    ),
    this.separatorStyle,
    this.digitTitleStyle,
    this.icon,
    this.suffixIcon,
    this.separator,
    this.replacement,
    this.onDone,
    this.durationTitle,
    this.separatorType = SeparatorType.symbol,
    this.slideDirection = SlideDirection.down,
    this.padding = const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
    this.separatorPadding = const EdgeInsets.symmetric(horizontal: 3.0),
    this.digitTitlePadding = const EdgeInsets.symmetric(horizontal: 3.0),
    this.showZeroValue = false,
    this.hideFirstDigitZero = false,
    this.showDigitTitles = false,
    this.decoration = const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      color: Color(0xFFF23333),
    ),
    this.curve = Curves.easeOut,
    this.countUp = false,
    this.infinityCountUp = false,
    this.slideAnimationDuration = const Duration(milliseconds: 300),
    this.textDirection,
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

  /// [TextStyle] is a parameter for all existing text,
  /// if this is null [SlideCountdown] has a default
  /// text style which will be of all text
  final TextStyle textStyle;

  /// [TextStyle] is a parameter for all existing text,
  /// if this is null [SlideCountdown] has a default
  /// text style which will be of all text
  final TextStyle? separatorStyle;

  /// [TextStyle] is a parameter for all existing text,
  /// if this is null [SlideCountdown] has a default
  /// text style which will be of all text
  final TextStyle? digitTitleStyle;

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

  /// if you want to change the separator type, change this value to
  /// [SeparatorType.title] or [SeparatorType.symbol].
  /// [SeparatorType.title] will display title between duration,
  /// e.g minutes or you can change to another language, by changing the value in [DurationTitle]
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

  /// if you want the digit titles to be visible under the digits set this value to true
  final bool showDigitTitles;

  /// you can change the slide animation up or down by changing the enum value in this property
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
  final TextDirection? textDirection;

  /// Override digits number
  /// Default 0-9
  final List<String>? digitsNumber;

  /// ImageFilter for optional backdrop filter
  final ImageFilter? filter;

  /// If you override [StreamDuration] package for stream a duration
  /// property [duration], [countUp], [infinityCountUp], and [onDone] in [SlideCountdown] not affected
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
  _SlideCountdownState createState() => _SlideCountdownState();
}

class _SlideCountdownState extends State<SlideCountdown> with CountdownMixin {
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
  void didUpdateWidget(covariant SlideCountdown oldWidget) {
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
        _streamDuration.durationLeft.listen(
          (duration) {
            _notifyDuration.streamDuration(duration);
            updateValue(duration);
            if (widget.onChanged != null) {
              widget.onChanged!(duration);
            }
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

        final days = DigitItem(
          firstDigit: daysFirstDigitNotifier,
          secondDigit: daysSecondDigitNotifier,
          textStyle: daysTextStyle,
          separatorStyle: widget.separatorStyle ?? widget.textStyle,
          digitTitleStyle: widget.digitTitleStyle ?? widget.textStyle,
          slideDirection: widget.slideDirection,
          curve: widget.curve,
          countUp: widget.countUp,
          slideAnimationDuration: widget.slideAnimationDuration,
          textDirection: widget.textDirection,
          hideFirstDigitZero: widget.hideFirstDigitZero,
          showSeparator: (showHours || showMinutes || showSeconds) || (isSeparatorTitle && showDays),
          digitTitle: widget.showDigitTitles ? durationTitle.days : null,
          separatorPadding: widget.separatorPadding,
          digitTitlePadding: widget.digitTitlePadding,
          separator: widget.separatorType == SeparatorType.title ? durationTitle.days : separator,
          digitsNumber: widget.digitsNumber,
          filter: widget.filter,
        );

        final hours = DigitItem(
          firstDigit: hoursFirstDigitNotifier,
          secondDigit: hoursSecondDigitNotifier,
          textStyle: widget.textStyle,
          separatorStyle: widget.separatorStyle ?? widget.textStyle,
          digitTitleStyle: widget.digitTitleStyle ?? widget.textStyle,
          slideDirection: widget.slideDirection,
          curve: widget.curve,
          countUp: widget.countUp,
          slideAnimationDuration: widget.slideAnimationDuration,
          textDirection: widget.textDirection,
          hideFirstDigitZero: widget.hideFirstDigitZero,
          showSeparator: (showMinutes || showSeconds) || (isSeparatorTitle && showHours),
          digitTitle: widget.showDigitTitles ? durationTitle.days : null,
          separatorPadding: widget.separatorPadding,
          digitTitlePadding: widget.digitTitlePadding,
          separator: widget.separatorType == SeparatorType.title ? durationTitle.hours : separator,
          digitsNumber: widget.digitsNumber,
          filter: widget.filter,
        );

        final minutes = DigitItem(
          firstDigit: minutesFirstDigitNotifier,
          secondDigit: minutesSecondDigitNotifier,
          textStyle: widget.textStyle,
          separatorStyle: widget.separatorStyle ?? widget.textStyle,
          digitTitleStyle: widget.digitTitleStyle ?? widget.textStyle,
          slideDirection: widget.slideDirection,
          curve: widget.curve,
          countUp: widget.countUp,
          slideAnimationDuration: widget.slideAnimationDuration,
          textDirection: widget.textDirection,
          hideFirstDigitZero: widget.hideFirstDigitZero,
          showSeparator: showSeconds || (isSeparatorTitle && showMinutes),
          digitTitle: widget.showDigitTitles ? durationTitle.days : null,
          separatorPadding: widget.separatorPadding,
          digitTitlePadding: widget.digitTitlePadding,
          separator: widget.separatorType == SeparatorType.title ? durationTitle.minutes : separator,
          digitsNumber: widget.digitsNumber,
          filter: widget.filter,
        );

        final seconds = DigitItem(
          firstDigit: secondsFirstDigitNotifier,
          secondDigit: secondsSecondDigitNotifier,
          textStyle: widget.textStyle,
          separatorStyle: widget.separatorStyle ?? widget.textStyle,
          digitTitleStyle: widget.digitTitleStyle ?? widget.textStyle,
          slideDirection: widget.slideDirection,
          curve: widget.curve,
          countUp: widget.countUp,
          slideAnimationDuration: widget.slideAnimationDuration,
          textDirection: widget.textDirection,
          hideFirstDigitZero: widget.hideFirstDigitZero,
          showSeparator: isSeparatorTitle && showSeconds,
          digitTitle: widget.showDigitTitles ? durationTitle.days : null,
          separatorPadding: widget.separatorPadding,
          digitTitlePadding: widget.digitTitlePadding,
          separator: widget.separatorType == SeparatorType.title ? durationTitle.seconds : separator,
          digitsNumber: widget.digitsNumber,
          filter: widget.filter,
        );

        final daysWidget = showDays ? days : const SizedBox.shrink();

        final hoursWidget = showHours ? hours : const SizedBox.shrink();

        final minutesWidget = showMinutes ? minutes : const SizedBox.shrink();

        final secondsWidget = showSeconds ? seconds : const SizedBox.shrink();

        final countdown = Padding(
          padding: widget.padding,
          child: Row(
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
          ),
        );

        return DecoratedBox(
          decoration: widget.decoration,
          child: countdown,
        );
      },
      child: widget.replacement,
    );
  }
}
