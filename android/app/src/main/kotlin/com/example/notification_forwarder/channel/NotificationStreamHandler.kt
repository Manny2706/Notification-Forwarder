package com.example.notification_forwarder.channel

import io.flutter.plugin.common.EventChannel

object NotificationStreamHandler {

    var eventSink: EventChannel.EventSink? = null

    fun send(data: Map<String, Any?>) {
        eventSink?.success(data)
    }
}