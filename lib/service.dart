import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:practice/data/book.dart';

class Service {
  final serverUrl = 'http://192.168.2.104:3000';
  DateTime lastModified = DateTime.now();

  Future<List<Book>> getAll() async {
    developer.log("get All - server call");
    http.Response response = await http.get(serverUrl+"/books",
        headers: {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.ifModifiedSinceHeader: lastModified.toString()
//        HttpHeaders.authorizationHeader: 'Bearer $token',
    } );
    if (response.statusCode == 200) { // or 304 not modified !!!
//      developer.log(response.body);
      Iterable decodedBody = json.decode(response.body);
      List<Book> books = decodedBody.map((i)=>Book.fromJson(i)).toList();
      print("200 OK");
      print(response.headers[HttpHeaders.lastModifiedHeader]);
      lastModified = DateTime.parse(response.headers[HttpHeaders.lastModifiedHeader]);
      return books;
    } else if (response.statusCode == 304) {
      print("304 not modified");
      return List<Book>();
    }
    else {
      throw Exception("Failed to load books from the Server");
    }
  }

  Future<bool> insert(Book book) async{
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader:'application/json',
      HttpHeaders.acceptHeader:'application/json',
    };
    final response = await http.post(serverUrl+"/book",
        headers: headers,
        body: json.encode({
          "id":book.id,
          "title":book.title,
          "date":book.creationDate.toString(),
        })
    );
    if(response.statusCode != 201){
      print("server add failed: " + response.body);
      return false;
    }
    return true;
  }

}
