import 'package:flutter/services.dart';

class NativeSettingsService {
  NativeSettingsService._();

  static final NativeSettingsService instance = NativeSettingsService._();

  static const MethodChannel _channel = MethodChannel(
    "notification_forwarder/methods",
  );

  // =========================
  // Brevo API Key
  // =========================

  Future<void> saveBrevoApiKey(String apiKey) async {
    await _channel.invokeMethod("saveBrevoApiKey", {"apiKey": apiKey});
  }

  Future<String> getBrevoApiKey() async {
    return await _channel.invokeMethod("getBrevoApiKey") ?? "";
  }

  // =========================
  // Sender Name
  // =========================

  Future<void> saveSenderName(String senderName) async {
    await _channel.invokeMethod("saveSenderName", {"senderName": senderName});
  }

  Future<String> getSenderName() async {
    return await _channel.invokeMethod("getSenderName") ?? "";
  }

  // =========================
  // Sender Email
  // =========================

  Future<void> saveSenderEmail(String senderEmail) async {
    await _channel.invokeMethod("saveSenderEmail", {
      "senderEmail": senderEmail,
    });
  }

  Future<String> getSenderEmail() async {
    return await _channel.invokeMethod("getSenderEmail") ?? "";
  }

  // =========================
  // Recipient Email
  // =========================

  Future<void> saveRecipientEmail(String recipientEmail) async {
    await _channel.invokeMethod("saveRecipientEmail", {
      "recipientEmail": recipientEmail,
    });
  }

  Future<String> getRecipientEmail() async {
    return await _channel.invokeMethod("getRecipientEmail") ?? "";
  }
}
