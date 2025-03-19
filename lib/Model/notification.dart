import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/googleapis_auth.dart';

Future<void> sendNotification(String id, String message) async {
  DocumentSnapshot doc =
      await FirebaseFirestore.instance.collection('employees').doc(id).get();

  String token = doc['token'];
  print(token);
  //------------------
  final accessToken = await getAccessToken();

  final url = Uri.parse(
      "https://fcm.googleapis.com/v1/projects/leave-mib/messages:send");
  final headers = {
    "Authorization": "Bearer $accessToken",
    "Content-Type": "application/json",
  };
  final body = jsonEncode({
    "message": {
      "token": token,
      "notification": {"title": "Notification", "body": message}
    }
  });

  final response = await http.post(url, headers: headers, body: body);
  print("Response: ${response.body}");
}

Future<String> getAccessToken() async {
  final credentials = ServiceAccountCredentials.fromJson(
      jsonDecode(await rootBundle.loadString('assets/service_account.json')));

  final client = await clientViaServiceAccount(
      credentials, ['https://www.googleapis.com/auth/firebase.messaging']);

  return client.credentials.accessToken.data;
}
