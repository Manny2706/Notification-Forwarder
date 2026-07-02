import 'package:flutter/services.dart';

class PermissionService {
  PermissionService._();

  static final PermissionService instance = PermissionService._();

  static const MethodChannel _channel = MethodChannel(
    'notification_forwarder/methods',
  );

  Future<void> openNotificationSettings() async {
    await _channel.invokeMethod("openNotificationSettings");
  }

  Future<bool> isNotificationAccessEnabled() async {
    final bool enabled = await _channel.invokeMethod(
      "isNotificationAccessEnabled",
    );
    Future<void> requestIgnoreBatteryOptimization() async {
      await _channel.invokeMethod("requestIgnoreBatteryOptimization");
    }

    Future<bool> isIgnoringBatteryOptimization() async {
      return await _channel.invokeMethod("isIgnoringBatteryOptimization") ??
          false;
    }

    return enabled;
  }
}
