import 'package:http/http.dart' as http;

class Request {
  static Future<String> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('An Error Occurred');
    }
  }

  static Future post(
    String url,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    final response = await http.post(
      Uri.parse(url),
      body: body,
      headers: headers,
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('An Error Occurred');
    }
  }
}
