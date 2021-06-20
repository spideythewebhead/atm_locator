import 'package:flutter/foundation.dart';

class ValueObserver<T> extends ValueListenable<T> {
  final _listeners = <VoidCallback>[];

  T _value;

  set value(T value) {
    if (value != _value) {
      _value = value;
      notifyListeners();
    }
  }

  @override
  T get value => _value;

  ValueObserver(this._value);

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(listener) {
    _listeners.remove(listener);
  }

  void notifyListeners() {
    for (final listener in _listeners) listener();
  }
}
