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
    required super.gradientColor,
    required super.separator,
    required super.fade,
    super.showSeparator = true,
    super.digitTitle,
    super.separatorPadding,
    super.digitTitlePadding,
    super.textDirection,
    super.digitsNumber,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final withOutAnimation = slideDirection == SlideDirection.none;
    final firstDigitWidget = withOutAnimation
        ? TextWithoutAnimation(
            value: firstDigit,
            textStyle: textStyle,
          )
        : TextAnimation(
            slideAnimationDuration: slideAnimationDuration,
            value: firstDigit,
            textStyle: textStyle,
            slideDirection: slideDirection,
            curve: curve,
            countUp: countUp,
            fade: fade,
            digitsNumber: digitsNumber,
          );

    final secondDigitWidget = withOutAnimation
        ? TextWithoutAnimation(
            value: secondDigit,
            textStyle: textStyle,
          )
        : TextAnimation(
            slideAnimationDuration: slideAnimationDuration,
            value: secondDigit,
            textStyle: textStyle,
            slideDirection: slideDirection,
            curve: curve,
            countUp: countUp,
            fade: fade,
            digitsNumber: digitsNumber,
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
      gradientColors: gradientColor,
      fade: fade,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              firstDigitWidget,
              secondDigitWidget,
            ],
          ),
          if (digitTitle != null) digitTitleWidget
        ],
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showSeparator && textDirection.isRtl) separatorWidget,
        box,
        if (showSeparator && !textDirection.isRtl) separatorWidget,
      ],
    );
  }
}
