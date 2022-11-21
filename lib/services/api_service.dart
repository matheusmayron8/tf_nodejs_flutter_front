import 'dart:convert';
import 'dart:html';

import 'package:dio/dio.dart';
import 'package:flutter_atv_final/models/notes.dart';
import 'package:flutter_atv_final/models/user_created_response.dart';
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
      final userData = UserData.fromJson(jsonDecode(response.body));
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("token", userData.token);
      return userData;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<UserCreateResponse> registerUser({
    required String name,
    required String login,
    required String password,
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/user/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'login': login,
        'password': password,
        'email': email
      }),
    );

    if (response.statusCode == HttpStatus.created) {
      return UserCreateResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to register ${response.statusCode}');
    }
  }

  Future<List<Notes>> getAllNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse('$_baseUrl/notes'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${prefs.getString('token')}'
      },
    );

    if (response.statusCode == HttpStatus.ok) {
      Iterable i = jsonDecode(response.body);
      return List<Notes>.from(i.map((model) => Notes.fromJson(model)));
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<List<Notes>> addNewNote({required String noteText}) async {
    final prefs = await SharedPreferences.getInstance();
    final response1 = await http.post(
      Uri.parse('$_baseUrl/notes'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${prefs.getString('token')}'
      },
      body: jsonEncode({'note': noteText}),
    );

    if (response1.statusCode == HttpStatus.created) {
      final response2 = await http.get(
        Uri.parse('$_baseUrl/notes'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${prefs.getString('token')}'
        },
      );

      if (response2.statusCode == HttpStatus.ok) {
        Iterable i = jsonDecode(response2.body);
        return List<Notes>.from(i.map((model) => Notes.fromJson(model)));
      } else {
        throw Exception(response2.statusCode);
      }
    } else {
      throw Exception(response1.statusCode);
    }
  }

  Future<List<Notes>> changeNoteStatus(
      {required int noteId, required bool completed}) async {
    final prefs = await SharedPreferences.getInstance();
    final response1 = await http.put(Uri.parse('$_baseUrl/notes/$noteId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${prefs.getString('token')}'
        },
        body: jsonEncode({'completed': completed}));

    if (response1.statusCode == HttpStatus.ok) {
      final prefs = await SharedPreferences.getInstance();
      final response2 = await http.get(
        Uri.parse('$_baseUrl/notes'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${prefs.getString('token')}'
        },
      );

      if (response2.statusCode == HttpStatus.ok) {
        Iterable i = jsonDecode(response2.body);
        return List<Notes>.from(i.map((model) => Notes.fromJson(model)));
      } else {
        throw Exception(response2.statusCode);
      }
    } else {
      throw Exception(response1.statusCode);
    }
  }

  Future<List<Notes>> deleteNote({required int noteId}) async {
    final prefs = await SharedPreferences.getInstance();
    final response1 = await http
        .delete(Uri.parse('$_baseUrl/notes/$noteId'), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${prefs.getString('token')}'
    });

    if (response1.statusCode == HttpStatus.noContent) {
      final prefs = await SharedPreferences.getInstance();
      final response2 = await http.get(
        Uri.parse('$_baseUrl/notes'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${prefs.getString('token')}'
        },
      );

      if (response2.statusCode == HttpStatus.ok) {
        Iterable i = jsonDecode(response2.body);
        return List<Notes>.from(i.map((model) => Notes.fromJson(model)));
      } else {
        throw Exception(response2.statusCode);
      }
    } else {
      throw Exception(response1.statusCode);
    }
  }
}
