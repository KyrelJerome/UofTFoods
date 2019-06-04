import 'package:flutter/material.dart';

import 'Store.dart';

class StoreFilter {
  String _label;
  String _toolTip;
  Function(bool) _action;
  Function update;
  Function(Store) _filter; // True means filter, false means do not filter.
  bool _isActive;
  Color selectedColor;
  Color disabledColor;
  bool filter(Store store) {
    if (!_isActive) {
      //Must be active
      return false;
    }
    return _filter(store);
  }

  List<Store> applyCounterFilter(List<Store> stores) {
    print("Applying Filter:" + _label);
    List<Store> filteredStores = List();
    if (!_isActive) {
      print("Not active!");
      return stores;
    }
    stores.forEach((Store store) {
      if (!_filter(store)) {
        filteredStores.add(store);
      }
    });
    return filteredStores;
  }

  StoreFilter(Function(bool) action, String tooltip, String label,
      bool isActive, Function(Store) filter) {
    _action = action;
    _filter = filter;
    _toolTip = tooltip;
    _label = label;
    _isActive = isActive;
  }
  get shortName {
    return _label;
  }

  get filterChip {
    return FilterChip(
      labelStyle: TextStyle(color: Colors.white),
      selectedColor: selectedColor ?? Colors.indigoAccent,
      disabledColor: disabledColor ?? Colors.blueGrey[400],
      backgroundColor: disabledColor ?? Colors.blueGrey[400],
      tooltip: _toolTip,
      selected: _isActive,
      label: Text(_label),
      onSelected: (bool) {
        print("FilterChip Clicked!");
        this._isActive = !_isActive;
        _action(_isActive);
      },
    );
  }
}
