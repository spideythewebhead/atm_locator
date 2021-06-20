import 'package:flutter/material.dart';

mixin OnContextReady<T extends StatefulWidget> on State<T> {
  var _didRun = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_didRun) {
      _didRun = true;
      onContextReady();
    }
  }

  void onContextReady();
}
