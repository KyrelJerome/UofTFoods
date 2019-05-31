import 'package:flutter/material.dart';

import 'Store.dart';

class StoreFilter {
  String _label;
  String _toolTip;
  Function(bool) _action;
  Function(Store) _filter;// True means filter, false means do not filter.
  bool _isActive;

  bool filter(Store store){
    if(_isActive){//Must be active
      return true;
    }
    return _filter(store);
  }
  StoreFilter(Function(bool) action, String tooltip, String label, bool isActive, Function(Store) filter){
    _action = action;
    _filter = filter;
    _toolTip = tooltip;
    _label = label;
    _isActive = isActive;
  }

  get filterChip {
    return FilterChip(
      tooltip: _toolTip ,
      selected: _isActive,
      label: Text(_label),
      onSelected: _action,
    );
  }
}
