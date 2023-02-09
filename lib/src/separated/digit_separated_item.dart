part of 'separated.dart';

class DigitSeparatedItem extends BaseDigitsSeparated {
  const DigitSeparatedItem({
    required super.height,
    required super.width,
    required super.decoration,
    required super.firstDigit,
    required super.secondDigit,
    required super.textStyle,
    required super.separatorStyle,
    required super.digitTitleStyle,
    required super.initValue,
    required super.slideDirection,
    required super.showZeroValue,
    required super.curve,
    required super.countUp,
    required super.slideAnimationDuration,
    required super.separator,
    required super.textDirection,
    required super.hideFirstDigitZero,
    super.showSeparator = true,
    super.digitTitle,
    super.separatorPadding,
    super.digitTitlePadding,
    super.digitsNumber,
    super.filter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final withoutAnimation = slideDirection == SlideDirection.none;

    final firstDigitWidget = withoutAnimation
        ? TextWithoutAnimation(
            value: firstDigit,
            textStyle: textStyle,
            hideFirstDigitZero: hideFirstDigitZero,
          )
        : TextAnimation(
            slideAnimationDuration: slideAnimationDuration,
            value: firstDigit,
            textStyle: textStyle,
            slideDirection: slideDirection,
            curve: curve,
            countUp: countUp,
            digitsNumber: digitsNumber,
            hideFirstDigitZero: hideFirstDigitZero,
          );

    final secondDigitWidget = withoutAnimation
        ? TextWithoutAnimation(
            value: secondDigit,
            textStyle: textStyle,
            hideFirstDigitZero: hideFirstDigitZero,
            isLastDigit: true,
          )
        : TextAnimation(
            slideAnimationDuration: slideAnimationDuration,
            value: secondDigit,
            textStyle: textStyle,
            slideDirection: slideDirection,
            curve: curve,
            countUp: countUp,
            digitsNumber: digitsNumber,
            hideFirstDigitZero: hideFirstDigitZero,
            isLastDigit: true,
          );

    final separatorWidget = Separator(
      padding: separatorPadding,
      show: showSeparator,
      separator: separator,
      style: separatorStyle,
    );

    final digitTitleWidget = Separator(
      padding: digitTitlePadding,
      show: digitTitle != null,
      separator: digitTitle ?? '',
      style: digitTitleStyle,
    );

    final box = BoxSeparated(
      height: height,
      width: width,
      decoration: decoration,
      child: _wrapBackdropFilter(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: textDirection.isRtl
                  ? [
                      secondDigitWidget,
                      firstDigitWidget,
                    ]
                  : [
                      firstDigitWidget,
                      secondDigitWidget,
                    ],
            ),
            if (digitTitle != null) digitTitleWidget
          ],
        ),
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (textDirection.isRtl && showSeparator) separatorWidget,
        box,
        if (!textDirection.isRtl && showSeparator) separatorWidget,
      ],
    );
  }

  Widget _wrapBackdropFilter({required Widget child}) => filter != null
      ? BackdropFilter(
          filter: filter!,
          child: child,
        )
      : child;
}
