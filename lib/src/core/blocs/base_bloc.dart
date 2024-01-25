import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseBloc<E, S> extends Bloc<E, S> with LifeCycle {
  BaseBloc(super.initialState);
}

/// controlled from you custom widget or [InstanceState]
mixin LifeCycle {
  /// Called immediately after the widget is allocated in memory.
  void onInit() {}

  /// Called 1 frame after onInit(). It is the perfect place to enter
  /// navigation, events, like snackBar, dialogs, or a new route
  void onReady() {}

  /// Called immediately before the widget is disposed
  void onDispose() {}
}
