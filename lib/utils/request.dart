import 'package:http/http.dart' as http;

Future<String> get(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('An Error Occurred');
  }
}

Future post(String url, Map<String, dynamic> body) async {
  final response = await http.post(Uri.parse(url), body: body);
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('An Error Occurred');
  }
}
