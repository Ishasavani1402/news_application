// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps
import 'dart:convert';
import 'package:news_application/models/Bitcoinmodel.dart';
import 'package:news_application/models/categorymodel.dart';
import 'package:news_application/models/news_headlines.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static Future<News_BBC> fetch_api(String channelName) async {
    var url =
        "https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=3a12573dc15a48ca8f2d49a46d251e60";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return News_BBC.fromJson(json);
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<CategoryModel> fetch_api_category(String categoryname) async {
    var url =
        "https://newsapi.org/v2/everything?q=${categoryname}&apiKey=3a12573dc15a48ca8f2d49a46d251e60";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return CategoryModel.fromJson(json);
    } else {
      throw Exception('Failed to load data');
    }
  }
  static Future<Bitcoin> fetch_api_bitcoim() async {
    var url =
        "https://newsapi.org/v2/everything?q=bitcoin&apiKey=3a12573dc15a48ca8f2d49a46d251e60";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return Bitcoin.fromJson(json);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
