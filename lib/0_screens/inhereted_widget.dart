import 'package:flutter/material.dart';

class TryWidget extends InheritedWidget {
  const TryWidget({super.key, required this.child, required this.rrr})
      : super(child: child);

  @override
  // ignore: overridden_fields
  final Widget child;
  final Color rrr;

  static TryWidget? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TryWidget>();
  }

  static TryWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TryWidget>();
  }

  @override
  bool updateShouldNotify(TryWidget oldWidget) {
    return true;
  }
}
