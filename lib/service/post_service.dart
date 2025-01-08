import 'dart:convert';

import 'package:http/http.dart' as http;
class PostService {
  static const String url = 'https://api.hive.blog/';
  static const String body = 
  '{"id":1,"jsonrpc":"2.0","method":"bridge.get_ranked_posts","params":{"sort":"trending","tag":"","observer":"hive.blog"}}';

  Future<List> fetchPosts() async {
    try{
     final response = await http.post(
      Uri.parse(url),
      headers: {
        'accept': 'application/json, text/plain, */*',
        'content-type': 'application/json',
      },
      body: body,
     );

     if(response.statusCode == 200){
      final dataResponse = jsonDecode(response.body);
      return dataResponse['result']?? [];
     }
     else{
       throw Exception('Falied to load posts');
     }

    }catch(e){
       throw Exception('Error fetching post $e');
    }
  }
}