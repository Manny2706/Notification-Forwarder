package com.example.notification_forwarder.model

data class NotificationData(
    val packageName: String,
    val title: String,
    val text: String,
    val postTime: Long
)