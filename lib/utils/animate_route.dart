import 'package:flutter/material.dart';

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({required WidgetBuilder builder, RouteSettings? settings })
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    if (settings.name == '/') {
      return child;
    }
    // Fades between routes. (If you don't want any animation,
    // just return child.)
    return child;
  }
}