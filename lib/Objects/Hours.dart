import 'dart:convert' show json;
class  Hours{
  //TODO add make formatting system, setters, getters, and whatever is required for "open, etc".
  Map<String, Map<String,int>> hours;
  factory Hours.fromJson(Map<String, dynamic> parsedJson){
   parsedJson.forEach((String day, dynamic)
    {
      Map<String, int> temp = json.decode(parsedJson[day]);
    }
   );
  }
  _getStartDateTimeJson(){

  }
  _getEndDateTimeJson(){

  }
  _getDayJson(){

  }
  getStartDateTime(){
    //return
  }
  getEndDateTime(){

  }
}