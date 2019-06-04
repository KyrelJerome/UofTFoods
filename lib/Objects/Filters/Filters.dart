import 'package:flutter/material.dart';

import '../Store.dart';
import '../StoreFilter.dart';

enum campuses { UTM, UTSG, UTSC }

class CampusFilter extends StoreFilter {
  CampusFilter(
    Function(bool) action,
    String name,
    String shortName,
    bool state,
  ) : super(action, "University of Toronto " + name, shortName, state,
            campusFilter(shortName));

  static Function(Store) campusFilter(String shortName) {
    return (Store store) {
      return shortName == store.campus;
    };
  }
}

class OpenFilter extends StoreFilter {
  OpenFilter(Function(bool) action, bool state)
      : super(action, "Show Only Open Stores", "Open", state, (Store store) {
          return store.isOpenNow();
        }) {
    super.selectedColor = Colors.green;
  }
}

class ClosedFilter extends StoreFilter {
  ClosedFilter(Function(bool) action, bool state)
      : super(action, "Show Only Closed Stores", "Closed", state,
            (Store store) {
          return !store.isOpenNow();
        }) {
    super.selectedColor = Colors.red;
  }
}
