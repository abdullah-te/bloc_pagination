import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

class CustomScrollOptions {
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final Axis scrollDirection;
  final bool reverse;
  final bool shrinkWrap;
  final Clip clipBehavior;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  CustomScrollOptions({
    this.controller,
    this.physics,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.shrinkWrap = false,
    this.clipBehavior = Clip.hardEdge,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  });
}
