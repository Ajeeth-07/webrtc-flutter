import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import '../utils/user_utils.dart';

String meetingApiUrl = 'http://192.168.1.12:4000/api';
var client = http.Client();

Future<http.Response> createMeeting() async {
  try {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var userId = await generateUserId();

    print('Sending request to create meeting...');
    var response = await client.post(
      Uri.parse('$meetingApiUrl/meeting/start'),
      headers: requestHeaders,
      body: jsonEncode({'hostId': userId, 'hostName': ''}),
    ).timeout(const Duration(seconds: 20));

    print('Received response: ${response.statusCode}');
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to create meeting: ${response.statusCode}');
    }
  } catch (e) {
    if (e is TimeoutException) {
      throw Exception('Connection timed out. Please check your server connection.');
    }
    throw Exception('Failed to create meeting: $e');
  }
}

Future<http.Response> joinMeeting(String meetingId) async {
  var response = await http.get(
    Uri.parse('$meetingApiUrl/meeting/join?meetingId=$meetingId'),
  );

  if (response.statusCode == 200 && response.statusCode < 400) {
    return response;
  }

  throw Exception('Not a valid meeting id');
}
