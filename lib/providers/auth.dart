import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final apiKey = 'AIzaSyBDgl0Gc74bq1L54pGBd4DrVzxa8xdy6sQ';
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$apiKey";

    final response = await http.post(
      url,
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    print(json.decode(response.body));

    return Future.value();
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
