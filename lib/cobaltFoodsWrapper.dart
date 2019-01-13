import 'dart:async';
import 'dart:convert' show json;
import 'package:http/http.dart' as http;
import 'Objects/Store.dart';
import 'Objects/Hours.dart';

///
/// The REST API returns words that rhyme or are related to [Topic].
class DataMuseApi {
  static const String key = 'bylTKgsa08vezNaD8VVdwrfx5vqnXN48';
  static const String keyParam = '/?key=' + key;
  /// The API endpoint we want to hit.
  static const String _url = 'cobalt.qas.im/api/1.0/food';
  static const String prefixSkip = 'limit';
  static const String prefixLimit = 'skip';
  static const String prefixSort = 'sort';
  String topicString;

  setTopicString(String topic){
   topicString = topic; 
  }
  /// Returns a list. Returns null on error.
  Future<List<String>> getFoodsJson(String word) async {
    final uri = 'https://'+ _url + keyParam;
    final jsonResponse = await _getJson(uri);
    List<String> jsonList = List();
    if (jsonResponse != null) {
      for (int i = 0; i < jsonResponse.length; i++) {
        if (jsonResponse[i] == null) {
          print('Error retrieving Store at index $i.');
        } else {
          
          jsonList.add(jsonResponse[i]);
        }
      }
    }
    return jsonList;
  }
/// Fetches and decodes a JSON object represented as a Dart [Map].
  /// Returns null if the API server is down, or the response is not JSON.
  Future<List<dynamic>> _getJson(String url) async {
    try {
      final responseBody = (await http.get(url + (topicString != null? topicPrefix+(topicString):'') )).body;
      // Finally, the string is parsed into a JSON object.
      return json.decode(responseBody);
    } on Exception catch (e) {
      print('$e');
      return null;
    }
  }
}
Store _getStoreFromJson(){

}
getStoreFromJson(){
  
}