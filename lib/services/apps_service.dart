import 'package:flutter/services.dart';
import '../models/app_info.dart';

class AppsService {
  AppsService._();

  static final AppsService instance = AppsService._();

  static const MethodChannel _channel = MethodChannel(
    'notification_forwarder/methods',
  );

  Future<List<AppInfo>> getInstalledApps() async {
    final List<dynamic> result = await _channel.invokeMethod(
      "getInstalledApps",
    );

    return result
        .map((e) => AppInfo.fromMap(Map<dynamic, dynamic>.from(e)))
        .toList();
  }
}
