import 'package:flutter/material.dart';

import 'Store.dart';

class StoreFilter {
  String _label;
  String _toolTip;
  Function(bool) _action;
  Function(Store) _filter;
  bool _state;// output the filter chip's state

  bool isFiltered(Store store){
    _state = _filter(store);
    return _state;
  }
  StoreFilter(Function(bool) action, String tooltip, String label, bool state, Function(Store) filter){
    _action = action;
    _filter = filter;
    _toolTip = tooltip;
    _label = label;
    _state = state;
  }

  get filterChip {
    return FilterChip(
      tooltip: _toolTip ,
      selected: _state,
      label: Text(_label),
      onSelected: _action,
    );
  }
}
