import 'dart:async';
import 'dart:convert' show json;
import 'package:http/http.dart' as http;
import 'package:deer_food/Objects/Hours.dart';
import 'package:deer_food/Objects/Store.dart';

///
/// The REST API returns words that rhyme or are related to [Topic].
class CobaltApi {
  static const String key = 'bylTKgsa08vezNaD8VVdwrfx5vqnXN48';
  static const String keyParam = '/?key=' + key;

  /// The API endpoint we want to hit.
  static const String _url = 'cobalt.qas.im/api/1.0/food';
  static const String prefixLimit = 'limit';
  static const String prefixSkip = 'skip';
  static const String prefixSort = 'sort';
  static const String prefixTags = 'tags';

  String limitString = '';
  String skipString = '';
  String sortString = '';
  List<String> tags = List();
  String query = '';

  reset() {
    query = '';
    removeLimit();
  }

  addTag(String tag) {
    tags.add(tag);
  }

  removeTags() {
    tags = List();
  }

  addlimit(int limit) {
    limitString = limit.toString();
  }

  removeLimit() {
    limitString = '';
  }

  /// Returns a list. Returns null on error.
  Future<List<Store>> getFoodsJson() async {
    final uri = 'https://' + _url + keyParam;
    final jsonResponse = await _getJson(uri);
    List<Store> jsonList = List();
    if (jsonResponse != null) {
      for (int i = 0; i < jsonResponse.length; i++) {
        if (jsonResponse[i] == null) {
          print('Error retrieving Store at index $i.');
        } else {
          jsonList.add(Store.fromJson(jsonResponse[i]));
        }
      }
    }
    return jsonList;
  }

  /// Fetches and decodes a JSON object represented as a Dart [Map].
  /// Returns null if the API server is down, or the response is not JSON.
  Future<List<dynamic>> _getJson(String url) async {
    try {
      final responseBody = (await http.get(url +
              (limitString != null ? prefixLimit + '=' + (limitString) : '')))
          .body;
      // Finally, the string is parsed into a JSON object.
      return json.decode(responseBody);
    } on Exception catch (e) {
      print('$e');
      return null;
    }
  }
}
