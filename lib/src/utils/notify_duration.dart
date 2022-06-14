import 'package:flutter/foundation.dart';

class NotifyDuration extends ValueNotifier<Duration> {
  NotifyDuration(Duration value) : super(value);

  streamDuration(Duration duration) {
    value = duration;
    notifyListeners();
  }
}
