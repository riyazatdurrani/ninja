
import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:ninja_test/user%20model/datamodel.dart';







class GetApiData {


  Future<List> getData() async {
    
    var url = Uri.parse('https://my-json-server.typicode.com/tryninjastudy/dummyapi/db');
    http.Response response = await http.get(url);
    JsonData jsondata = JsonData.fromJson(json.decode(response.body));
    var tempdata = jsondata.restaurant!.toList();
     List conversations = [];
     for (var x in tempdata){
     conversations.add(x.toJson());
     }
   
    return conversations;
  }
  
  
  void putData(List a)async{
  var box = await Hive.openBox('test1.1');
  box.add(a.toList());
 
}
}

  