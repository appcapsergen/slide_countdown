import 'package:flutter/foundation.dart';

/// {@template notify_duration}
/// A [ValueNotifier] that wraps a [Duration].
/// {@endtemplate}
class NotifyDuration extends ValueNotifier<Duration> {
  /// {@macro notify_duration}
  NotifyDuration(super.value);

  /// Updates the value of [Duration].
  streamDuration(Duration duration) {
    value = duration;
    notifyListeners();
  }
}
