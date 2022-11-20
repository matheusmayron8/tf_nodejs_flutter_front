import 'dart:convert';
import 'dart:html';

import 'package:dio/dio.dart';
import 'package:flutter_atv_final/models/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final _dio = Dio();

  static const _baseUrl = "https://api-tf-nodejs.herokuapp.com/api";

  Future<UserData> getToken({
    required String login,
    required String password,
  }) async {
    final response = await http.post(Uri.parse('$_baseUrl/user/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body:
            jsonEncode(<String, String>{'login': login, 'password': password}));

    if (response.statusCode == HttpStatus.ok) {
      return UserData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }
}
