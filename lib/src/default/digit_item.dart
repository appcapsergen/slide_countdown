part of 'default.dart';

class DigitItem extends BaseDigits {
  const DigitItem({
    required super.firstDigit,
    required super.secondDigit,
    required super.textStyle,
    required super.separatorStyle,
    required super.slideDirection,
    required super.curve,
    required super.countUp,
    required super.slideAnimationDuration,
    required super.separator,
    required super.fade,
    super.showSeparator = true,
    super.separatorPadding,
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
            digitsNumber: digitsNumber,
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
            digitsNumber: digitsNumber,
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

    List<Widget> children = textDirection.isRtl
        ? [
            separatorWidget,
            secondDigitWidget,
            firstDigitWidget,
          ]
        : [
            firstDigitWidget,
            secondDigitWidget,
            separatorWidget,
          ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
