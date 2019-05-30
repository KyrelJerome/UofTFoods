import '../Store.dart';
import '../StoreFilter.dart';

enum campuses { UTM, UTSG, UTSC }

class CampusFilter extends StoreFilter {
  CampusFilter(
    dynamic action,
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
