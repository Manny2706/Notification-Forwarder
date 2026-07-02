import 'package:flutter/services.dart';

class AppSelectionService {
  AppSelectionService._();

  static final AppSelectionService instance = AppSelectionService._();

  static const MethodChannel _channel = MethodChannel(
    "notification_forwarder/methods",
  );

  Future<void> saveSelectedApps(List<String> packages) async {
    await _channel.invokeMethod("saveSelectedApps", packages);
  }

  Future<List<String>> getSelectedApps() async {
    final List<dynamic> result = await _channel.invokeMethod("getSelectedApps");

    return result.cast<String>();
  }
}
