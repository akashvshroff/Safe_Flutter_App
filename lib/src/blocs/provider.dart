import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'bloc.dart';
export 'bloc.dart';

class Provider extends InheritedWidget {
  final Bloc bloc;
  Provider({Key key, Widget child})
      : bloc = Bloc(),
        super(key: key, child: child);

  static Bloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>()).bloc;
  }

  bool updateShouldNotify(_) => true;
}
