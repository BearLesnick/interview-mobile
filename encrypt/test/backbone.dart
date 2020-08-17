Future<void> reschedule({int times}) async {
  if (times == null) {
    return Future<void>.value(null);
  } else if (times < 1) {
    throw ArgumentError("Times must me positive");
  } else {
    for (var i = 0; i < times; i++) {
      await reschedule();
    }
  }
}
