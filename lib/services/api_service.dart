import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/payment_notification.dart';

class ApiService {
  ApiService._();

  static final ApiService instance = ApiService._();

  static const String baseUrl = "https://notification-forwarder.onrender.com";

  static const String token =
      "f7b503d7d7263b45a0398c8fd56273f98a6e065d24602ea4c4dc34369b75a0a3";

  Future<void> forwardNotification(PaymentNotification notification) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/forward"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "email": "mayankgupta270606@gmail.com",
          "app": _getAppName(notification.packageName),
          "title": notification.title,
          "message": notification.text,
        }),
      );

      debugPrint("Status: ${response.statusCode}");
      debugPrint("Body: ${response.body}");

      if (response.statusCode == 200) {
        debugPrint("Notification forwarded successfully");
      } else {
        debugPrint("API Error ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Failed to send notification: $e");
    }
  }

  String _getAppName(String packageName) {
    switch (packageName) {
      case "com.google.android.apps.nbu.paisa.user":
        return "Google Pay";

      case "com.phonepe.app":
        return "PhonePe";

      case "net.one97.paytm":
        return "Paytm";

      case "in.org.npci.upiapp":
        return "BHIM";

      default:
        return packageName;
    }
  }
}
