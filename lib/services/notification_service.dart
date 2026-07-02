import 'dart:async';

import 'package:flutter/services.dart';
import '../models/payment_notification.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const EventChannel _eventChannel = EventChannel(
    'notification_forwarder/events',
  );

  Stream<PaymentNotification> get notificationStream {
    return _eventChannel.receiveBroadcastStream().map((event) {
      return PaymentNotification.fromMap(Map<String, dynamic>.from(event));
    });
  }
}
