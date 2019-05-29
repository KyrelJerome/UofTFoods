import 'package:flutter/material.dart';

class StoreFilter {
  String _label;
  String _toolTip;
  Function(bool) _action;
  Function _filter;
  bool state;

  bool isFiltered(){
    return _filter();
  }
  StoreFilter({_action, _filter: filter, })
  get filterChip {
    return FilterChip(
      tooltip: _toolTip ,
      selected: state,
      label: Text(_label),
      onSelected: _action,
    );
  }
}
